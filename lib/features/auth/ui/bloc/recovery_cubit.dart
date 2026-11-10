import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/auth/domain/auth_models.dart';
import 'package:findu/features/auth/domain/auth_repository.dart';

enum RecoveryStatus { idle, loading, done, failure }

class RecoveryState {
  const RecoveryState({
    this.status = RecoveryStatus.idle,
    this.error,
    this.email,
  });

  final RecoveryStatus status;
  final String? error;
  final String? email;
}

class RecoveryCubit extends Cubit<RecoveryState> {
  RecoveryCubit(this._repository) : super(const RecoveryState());

  final AuthRepository _repository;

  Future<void> sendCode(String user) => _run(() async {
    final email = await _repository.sendRecoveryCode(user);
    emit(RecoveryState(status: RecoveryStatus.done, email: email));
  });

  Future<void> verifyCode({required String email, required String code}) =>
      _run(() async {
        await _repository.verifyRecoveryCode(email: email, code: code);
        emit(RecoveryState(status: RecoveryStatus.done, email: email));
      });

  Future<void> updatePassword(String password) => _run(() async {
    await _repository.updatePassword(password);
    await _repository.signOut();
    emit(const RecoveryState(status: RecoveryStatus.done));
  });

  Future<void> _run(Future<void> Function() action) async {
    emit(const RecoveryState(status: RecoveryStatus.loading));
    try {
      await action();
    } on AuthFailure catch (e) {
      emit(RecoveryState(status: RecoveryStatus.failure, error: e.message));
    } catch (_) {
      emit(
        const RecoveryState(
          status: RecoveryStatus.failure,
          error: 'Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }
}
