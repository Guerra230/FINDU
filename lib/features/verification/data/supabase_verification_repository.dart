import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:findu/features/verification/domain/verification_repository.dart';

class SupabaseVerificationRepository implements VerificationRepository {
  SupabaseVerificationRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<VerificationQuestion>> questions(String postId) async {
    final rows = await _client
        .from('preguntas_verificacion')
        .select('id, texto, orden')
        .eq('publicacion_id', postId)
        .order('orden');
    return rows
        .map(
          (r) => VerificationQuestion(
            id: r['id'] as String,
            text: r['texto'] as String,
            order: r['orden'] as int,
          ),
        )
        .toList();
  }

  @override
  Future<VerificationResult> verify({
    required String postId,
    required List<String> answers,
  }) async {
    try {
      final data =
          await _client.rpc(
                'verificar_respuestas',
                params: {'p_publicacion': postId, 'p_respuestas': answers},
              )
              as Map<String, dynamic>;
      return VerificationResult(
        approved: data['aprobado'] as bool,
        results: (data['resultados'] as List).cast<bool>(),
        attemptsLeft: data['intentos_restantes'] as int,
        conversationId: data['conversacion_id'] as String?,
      );
    } on PostgrestException catch (e) {
      if (e.message.contains('sin_intentos')) {
        throw const VerificationFailure(
          'Ya usaste tus 2 intentos para esta publicación.',
        );
      }
      throw const VerificationFailure(
        'No pudimos verificar tus respuestas. Intenta de nuevo.',
      );
    }
  }

  @override
  Future<String> reportFound({
    required String postId,
    required String where,
    required String condition,
    required List<Uint8List> photos,
  }) async {
    final uid = _client.auth.currentUser!.id;
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final urls = <String>[];
    for (var i = 0; i < photos.length; i++) {
      final path = '$uid/reportes/$postId-$stamp-${i + 1}.jpg';
      await _client.storage
          .from('fotos')
          .uploadBinary(
            path,
            photos[i],
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );
      urls.add(_client.storage.from('fotos').getPublicUrl(path));
    }
    final id = await _client.rpc(
      'reportar_hallazgo',
      params: {
        'p_publicacion': postId,
        'p_donde': where,
        'p_estado': condition,
        'p_fotos': urls,
      },
    );
    return id as String;
  }
}
