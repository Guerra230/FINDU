part of 'auth_bloc.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated, failure }

class AuthState {
  const AuthState({this.status = AuthStatus.unknown, this.profile, this.error});

  final AuthStatus status;
  final Profile? profile;
  final String? error;

  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({AuthStatus? status, Profile? profile, String? error}) =>
      AuthState(
        status: status ?? this.status,
        profile: profile ?? this.profile,
        error: error,
      );
}
