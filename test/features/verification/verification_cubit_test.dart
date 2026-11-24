import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/features/verification/domain/verification_repository.dart';
import 'package:findu/features/verification/ui/bloc/verification_cubit.dart';
import 'package:findu/features/verification/verification_di.dart';

class FakeVerificationRepository implements VerificationRepository {
  List<String>? recibidas;

  @override
  Future<List<VerificationQuestion>> questions(String postId) async => const [
    VerificationQuestion(id: 'q1', text: '¿Color?', order: 1),
    VerificationQuestion(id: 'q2', text: '¿Marca?', order: 2),
  ];

  @override
  Future<VerificationResult> verify({
    required String postId,
    required List<String> answers,
  }) async {
    recibidas = answers;
    final ok = answers.first == 'azul';
    return VerificationResult(
      approved: ok,
      results: [ok, true],
      attemptsLeft: 1,
      conversationId: ok ? 'chat-1' : null,
    );
  }

  @override
  Future<String> reportFound({
    required String postId,
    required String where,
    required String condition,
    required List<Uint8List> photos,
  }) async => 'chat-2';
}

void main() {
  late FakeVerificationRepository repository;

  setUp(() async {
    await sl.reset();
    repository = FakeVerificationRepository();
    sl.registerLazySingleton<VerificationRepository>(() => repository);
    registrarVerificacion(sl);
  });

  test('GetIt crea el cubit con el id de la publicación', () {
    final cubit = sl<VerificationCubit>(param1: 'post-9');

    expect(cubit.postId, 'post-9');
    cubit.close();
  });

  test('responder bien aprueba y devuelve el chat', () async {
    final cubit = sl<VerificationCubit>(param1: 'post-1');
    await cubit.load();
    expect(cubit.state.status, VerificationStatus.answering);
    expect(cubit.state.questions, hasLength(2));

    cubit.answer('azul');
    await cubit.next();
    cubit.answer('Totto');
    await cubit.next();

    expect(cubit.state.status, VerificationStatus.finished);
    expect(cubit.state.result!.approved, isTrue);
    expect(cubit.state.result!.conversationId, 'chat-1');
    expect(repository.recibidas, ['azul', 'Totto']);
    await cubit.close();
  });

  test('no envía si falta una respuesta', () async {
    final cubit = sl<VerificationCubit>(param1: 'post-1');
    await cubit.load();

    cubit.answer('azul');
    await cubit.next();
    await cubit.next();

    expect(cubit.state.status, VerificationStatus.answering);
    expect(cubit.state.error, 'Responde todas las preguntas');
    expect(repository.recibidas, isNull);
    await cubit.close();
  });
}
