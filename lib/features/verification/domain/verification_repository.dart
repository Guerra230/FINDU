import 'dart:typed_data';

class VerificationQuestion {
  const VerificationQuestion({
    required this.id,
    required this.text,
    required this.order,
  });

  final String id;
  final String text;
  final int order;
}

class VerificationResult {
  const VerificationResult({
    required this.approved,
    required this.results,
    required this.attemptsLeft,
    this.conversationId,
  });

  final bool approved;
  final List<bool> results;
  final int attemptsLeft;
  final String? conversationId;
}

class VerificationFailure implements Exception {
  const VerificationFailure(this.message);

  final String message;
}

abstract interface class VerificationRepository {
  Future<List<VerificationQuestion>> questions(String postId);

  Future<VerificationResult> verify({
    required String postId,
    required List<String> answers,
  });

  Future<String> reportFound({
    required String postId,
    required String where,
    required String condition,
    required List<Uint8List> photos,
  });
}
