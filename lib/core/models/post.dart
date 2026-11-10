import 'package:flutter/material.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/supabase/supabase_setup.dart';
import 'package:findu/core/utils/formatters.dart';

enum PostKind { object, pet }

enum PostIntent { lost, found }

class Post {
  const Post({
    required this.id,
    required this.title,
    required this.kind,
    required this.intent,
    required this.category,
    required this.place,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
    required this.state,
    required this.latitude,
    required this.longitude,
    this.description,
    this.reward,
    this.imageUrl,
    this.color,
    this.brand,
    this.petName,
    this.breed,
    this.age,
  });

  final String id;
  final String title;
  final PostKind kind;
  final PostIntent intent;
  final String category;
  final String place;
  final DateTime createdAt;
  final String authorId;
  final String authorName;
  final String state;
  final double latitude;
  final double longitude;
  final String? description;
  final int? reward;
  final String? imageUrl;
  final String? color;
  final String? brand;
  final String? petName;
  final String? breed;
  final String? age;

  static const selectColumns =
      'id, titulo, descripcion, tipo, intencion, estado, latitud, longitud, recompensa_cop, creado_en, autor_id, '
      'autor:perfiles!publicaciones_autor_id_fkey(nombre), categoria:categorias(nombre), lugar:lugares(nombre), '
      'fotos(url, orden), detalles_objeto(color, marca), detalles_mascota(nombre, especie, raza, edad)';

  factory Post.fromRow(Map<String, dynamic> row) {
    Map<String, dynamic>? one(Object? value) {
      if (value is Map<String, dynamic>) return value;
      if (value is List &&
          value.isNotEmpty &&
          value.first is Map<String, dynamic>) {
        return value.first as Map<String, dynamic>;
      }
      return null;
    }

    final photos =
        (row['fotos'] as List?)?.cast<Map<String, dynamic>>().toList() ?? [];
    photos.sort(
      (a, b) => (a['orden'] as num? ?? 0).compareTo(b['orden'] as num? ?? 0),
    );
    final object = one(row['detalles_objeto']);
    final pet = one(row['detalles_mascota']);

    return Post(
      id: row['id'] as String,
      title: row['titulo'] as String,
      kind: row['tipo'] == 'mascota' ? PostKind.pet : PostKind.object,
      intent: row['intencion'] == 'perdido'
          ? PostIntent.lost
          : PostIntent.found,
      category: one(row['categoria'])?['nombre'] as String? ?? 'Otro',
      place: one(row['lugar'])?['nombre'] as String? ?? 'Cali',
      createdAt: DateTime.parse(row['creado_en'] as String),
      authorId: row['autor_id'] as String,
      authorName: one(row['autor'])?['nombre'] as String? ?? 'Usuario FINDU',
      state: row['estado'] as String? ?? 'activa',
      latitude: (row['latitud'] as num?)?.toDouble() ?? 0,
      longitude: (row['longitud'] as num?)?.toDouble() ?? 0,
      description: row['descripcion'] as String?,
      reward: row['recompensa_cop'] as int?,
      imageUrl: photos.isEmpty ? null : photos.first['url'] as String?,
      color: object?['color'] as String?,
      brand: object?['marca'] as String?,
      petName: pet?['nombre'] as String?,
      breed: pet?['raza'] as String?,
      age: pet?['edad'] as String?,
    );
  }

  bool get isPet => kind == PostKind.pet;

  bool get isLost => intent == PostIntent.lost;

  bool get isMine => authorId == SupabaseSetup.userId;

  bool get isDelivered => state == 'entregada' || state == 'cerrada';

  String get ago => timeAgo(createdAt);

  String get placeAgo => '$place, $ago';

  String get firstName => authorName.split(' ').first;

  bool get feminine {
    if (isPet) return title.toLowerCase().endsWith('a') || category == 'Gata';
    return const {
      'Mochila',
      'Billetera',
      'Cartuchera',
      'Llaves',
    }.contains(category);
  }

  FdStatus get status => isLost ? FdStatus.lost : FdStatus.found;

  ImageProvider? get image => imageUrl == null ? null : NetworkImage(imageUrl!);

  IconData get icon => switch (category) {
    'Gato' || 'Perro' => Icons.pets_rounded,
    'Mochila' => Icons.backpack_outlined,
    'Billetera' => Icons.account_balance_wallet_outlined,
    'Termo' => Icons.local_drink_outlined,
    'Cartuchera' => Icons.edit_outlined,
    'Celular' => Icons.phone_android_rounded,
    'Parlante' => Icons.speaker_outlined,
    'Llaves' => Icons.key_rounded,
    'Audífonos' => Icons.headphones_rounded,
    _ => isPet ? Icons.pets_rounded : Icons.inventory_2_outlined,
  };
}
