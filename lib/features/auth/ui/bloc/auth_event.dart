part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.user, required this.password});

  final String user;
  final String password;
}

final class AuthStudentSignUpRequested extends AuthEvent {
  const AuthStudentSignUpRequested({
    required this.draft,
    required this.university,
  });

  final StudentDraft draft;
  final University university;
}

final class AuthCitizenSignUpRequested extends AuthEvent {
  const AuthCitizenSignUpRequested({
    required this.name,
    required this.phone,
    required this.password,
  });

  final String name;
  final String phone;
  final String password;
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
