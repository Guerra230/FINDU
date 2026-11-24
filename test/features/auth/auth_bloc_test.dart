import 'package:flutter_test/flutter_test.dart';

import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/features/auth/auth_di.dart';
import 'package:findu/features/auth/domain/auth_models.dart';
import 'package:findu/features/auth/domain/auth_repository.dart';
import 'package:findu/features/auth/ui/bloc/auth_bloc.dart';

class FakeAuthRepository implements AuthRepository {
  bool session = false;

  @override
  bool get hasSession => session;

  @override
  Future<Profile?> currentProfile() async =>
      const Profile(id: 'u1', name: 'Juan', isStudent: true);

  @override
  Future<void> signIn({required String user, required String password}) async {
    if (password != '12345678') {
      throw const AuthFailure('Correo, celular o contraseña incorrectos');
    }
    session = true;
  }

  @override
  Future<void> signOut() async => session = false;

  @override
  Future<void> signUpStudent({
    required StudentDraft draft,
    required University university,
  }) async {}

  @override
  Future<void> signUpCitizen({
    required String name,
    required String phone,
    required String password,
  }) async {}

  @override
  Future<String> sendRecoveryCode(String user) async => user;

  @override
  Future<void> verifyRecoveryCode({
    required String email,
    required String code,
  }) async {}

  @override
  Future<void> updatePassword(String password) async {}

  @override
  Future<List<University>> universities() async => const [];
}

void main() {
  setUp(() async {
    await sl.reset();
    sl.registerLazySingleton<AuthRepository>(FakeAuthRepository.new);
    registrarAuth(sl);
  });

  test('sin sesión el AuthBloc queda sin autenticar', () async {
    final bloc = sl<AuthBloc>()..add(const AuthStarted());

    final estado = await bloc.stream.first;

    expect(estado.status, AuthStatus.unauthenticated);
    await bloc.close();
  });

  test('login correcto carga el perfil', () async {
    final bloc = sl<AuthBloc>()
      ..add(
        const AuthLoginRequested(
          user: 'juan@u.icesi.edu.co',
          password: '12345678',
        ),
      );

    final estado = await bloc.stream.firstWhere(
      (s) => s.status == AuthStatus.authenticated,
    );

    expect(estado.profile!.name, 'Juan');
    await bloc.close();
  });

  test('login con contraseña mala muestra el error', () async {
    final bloc = sl<AuthBloc>()
      ..add(
        const AuthLoginRequested(
          user: 'juan@u.icesi.edu.co',
          password: 'malamala',
        ),
      );

    final estado = await bloc.stream.firstWhere(
      (s) => s.status == AuthStatus.failure,
    );

    expect(estado.error, 'Correo, celular o contraseña incorrectos');
    await bloc.close();
  });
}
