import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/verification/domain/verification_repository.dart';

enum VerificationStatus { loading, answering, sending, finished, failure }

class VerificationState {
  const VerificationState({
    this.status = VerificationStatus.loading,
    this.questions = const [],
    this.answers = const [],
    this.index = 0,
    this.result,
    this.error,
  });

  final VerificationStatus status;
  final List<VerificationQuestion> questions;
  final List<String> answers;
  final int index;
  final VerificationResult? result;
  final String? error;

  bool get isLast => index >= questions.length - 1;

  String get currentAnswer => index < answers.length ? answers[index] : '';

  VerificationState copyWith({
    VerificationStatus? status,
    List<String>? answers,
    int? index,
    VerificationResult? result,
    String? error,
  }) => VerificationState(
    status: status ?? this.status,
    questions: questions,
    answers: answers ?? this.answers,
    index: index ?? this.index,
    result: result ?? this.result,
    error: error,
  );
}

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit(this._repository, this.postId)
    : super(const VerificationState());

  final VerificationRepository _repository;
  final String postId;

  Future<void> load() async {
    try {
      final questions = await _repository.questions(postId);
      if (questions.isEmpty) {
        emit(
          const VerificationState(
            status: VerificationStatus.failure,
            error: 'Esta publicación no tiene preguntas.',
          ),
        );
        return;
      }
      emit(
        VerificationState(
          status: VerificationStatus.answering,
          questions: questions,
          answers: List.filled(questions.length, ''),
        ),
      );
    } catch (_) {
      emit(
        const VerificationState(
          status: VerificationStatus.failure,
          error: 'No pudimos cargar las preguntas.',
        ),
      );
    }
  }

  void answer(String value) {
    final answers = [...state.answers]..[state.index] = value;
    emit(state.copyWith(answers: answers));
  }

  bool back() {
    if (state.index == 0) return false;
    emit(state.copyWith(index: state.index - 1));
    return true;
  }

  Future<void> next() async {
    if (!state.isLast) {
      emit(state.copyWith(index: state.index + 1));
      return;
    }
    emit(state.copyWith(status: VerificationStatus.sending));
    try {
      final result = await _repository.verify(
        postId: postId,
        answers: state.answers,
      );
      emit(state.copyWith(status: VerificationStatus.finished, result: result));
    } on VerificationFailure catch (e) {
      emit(
        state.copyWith(status: VerificationStatus.answering, error: e.message),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: VerificationStatus.answering,
          error: 'Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }
}
