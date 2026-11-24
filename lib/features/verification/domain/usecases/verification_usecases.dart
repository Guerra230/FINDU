import 'dart:typed_data';

import 'package:findu/features/verification/domain/verification_repository.dart';

class ObtenerPreguntas {
  const ObtenerPreguntas(this._repository);

  final VerificationRepository _repository;

  Future<List<VerificationQuestion>> call(String postId) =>
      _repository.questions(postId);
}

class VerificarRespuestas {
  const VerificarRespuestas(this._repository);

  final VerificationRepository _repository;

  Future<VerificationResult> call({
    required String postId,
    required List<String> answers,
  }) {
    if (answers.any((a) => a.trim().isEmpty)) {
      throw const VerificationFailure('Responde todas las preguntas');
    }
    return _repository.verify(postId: postId, answers: answers);
  }
}

class ReportarHallazgo {
  const ReportarHallazgo(this._repository);

  final VerificationRepository _repository;

  Future<String> call({
    required String postId,
    required String where,
    required String condition,
    required List<Uint8List> photos,
  }) {
    if (photos.isEmpty) {
      throw const VerificationFailure('Agrega al menos una foto');
    }
    return _repository.reportFound(
      postId: postId,
      where: where,
      condition: condition,
      photos: photos,
    );
  }
}
