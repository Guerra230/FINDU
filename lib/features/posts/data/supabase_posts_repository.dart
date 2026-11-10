import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:findu/core/models/post.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';

class SupabasePostsRepository implements PostsRepository {
  SupabasePostsRepository(this._client);

  final SupabaseClient _client;

  static const bucket = 'fotos';

  @override
  Future<List<Post>> feed() async {
    final rows = await _client
        .from('publicaciones')
        .select(Post.selectColumns)
        .inFilter('estado', ['activa', 'en_verificacion'])
        .order('creado_en', ascending: false)
        .limit(100);
    return rows.map(Post.fromRow).toList();
  }

  @override
  Future<List<Post>> mine() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return [];
    final rows = await _client
        .from('publicaciones')
        .select(Post.selectColumns)
        .eq('autor_id', uid)
        .order('creado_en', ascending: false);
    return rows.map(Post.fromRow).toList();
  }

  @override
  Future<Post> byId(String id) async {
    final row = await _client
        .from('publicaciones')
        .select(Post.selectColumns)
        .eq('id', id)
        .single();
    return Post.fromRow(row);
  }

  @override
  Future<String> create(NewPost post) async {
    final uid = _client.auth.currentUser!.id;
    final type = post.kind == PostKind.pet ? 'mascota' : 'objeto';

    final category = await _client
        .from('categorias')
        .select('id')
        .eq('tipo', type)
        .eq('nombre', post.category)
        .maybeSingle();
    final place = await _client
        .from('lugares')
        .select('id, latitud, longitud')
        .eq('nombre', post.place)
        .limit(1)
        .maybeSingle();

    final inserted = await _client
        .from('publicaciones')
        .insert({
          'autor_id': uid,
          'categoria_id': category?['id'] ?? await _otherCategory(type),
          'lugar_id': place?['id'],
          'tipo': type,
          'intencion': post.intent == PostIntent.lost
              ? 'perdido'
              : 'encontrado',
          'titulo': post.title.trim(),
          'descripcion': post.description?.trim(),
          'latitud': place?['latitud'] ?? 3.4516,
          'longitud': place?['longitud'] ?? -76.532,
          'recompensa_cop': post.intent == PostIntent.lost ? post.reward : null,
        })
        .select('id')
        .single();
    final postId = inserted['id'] as String;

    if (post.kind == PostKind.pet) {
      await _client.from('detalles_mascota').insert({
        'publicacion_id': postId,
        'nombre': post.petName,
        'especie': switch (post.category) {
          'Perro' => 'perro',
          'Gato' => 'gato',
          _ => 'otro',
        },
        'raza': post.breed,
      });
    } else {
      await _client.from('detalles_objeto').insert({'publicacion_id': postId});
    }

    for (var i = 0; i < post.photos.length; i++) {
      final path = '$uid/$postId/${i + 1}.jpg';
      await _client.storage
          .from(bucket)
          .uploadBinary(
            path,
            post.photos[i],
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );
      await _client.from('fotos').insert({
        'publicacion_id': postId,
        'url': _client.storage.from(bucket).getPublicUrl(path),
        'orden': i + 1,
      });
    }

    for (var i = 0; i < post.questions.length; i++) {
      await _client.rpc(
        'agregar_pregunta',
        params: {
          'p_publicacion': postId,
          'p_texto': post.questions[i].text,
          'p_respuesta': post.questions[i].answer,
          'p_orden': i + 1,
        },
      );
    }

    return postId;
  }

  Future<String> _otherCategory(String type) async {
    final row = await _client
        .from('categorias')
        .select('id')
        .eq('tipo', type)
        .eq('nombre', 'Otro')
        .single();
    return row['id'] as String;
  }
}
