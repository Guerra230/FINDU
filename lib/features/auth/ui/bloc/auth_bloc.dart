import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:findu/features/auth/domain/auth_models.dart';
import 'package:findu/features/auth/domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required HaySesion haySesion,
    required ObtenerPerfilActual obtenerPerfil,
    required IniciarSesion iniciarSesion,
    required RegistrarUniversitario registrarUniversitario,
    required RegistrarCiudadano registrarCiudadano,
    required CerrarSesion cerrarSesion,
  }) : _haySesion = haySesion,
       _obtenerPerfil = obtenerPerfil,
       _iniciarSesion = iniciarSesion,
       _registrarUniversitario = registrarUniversitario,
       _registrarCiudadano = registrarCiudadano,
       _cerrarSesion = cerrarSesion,
       super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthStudentSignUpRequested>(_onStudentSignUp);
    on<AuthCitizenSignUpRequested>(_onCitizenSignUp);
    on<AuthLogoutRequested>(_onLogout);
  }

  final HaySesion _haySesion;
  final ObtenerPerfilActual _obtenerPerfil;
  final IniciarSesion _iniciarSesion;
  final RegistrarUniversitario _registrarUniversitario;
  final RegistrarCiudadano _registrarCiudadano;
  final CerrarSesion _cerrarSesion;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    if (!_haySesion()) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
      return;
    }
    await _loadProfile(emit);
  }

  Future<void> _onLogin(AuthLoginRequested event, Emitter<AuthState> emit) =>
      _run(
        emit,
        () => _iniciarSesion(user: event.user, password: event.password),
      );

  Future<void> _onStudentSignUp(
    AuthStudentSignUpRequested event,
    Emitter<AuthState> emit,
  ) => _run(
    emit,
    () => _registrarUniversitario(
      draft: event.draft,
      university: event.university,
    ),
  );

  Future<void> _onCitizenSignUp(
    AuthCitizenSignUpRequested event,
    Emitter<AuthState> emit,
  ) => _run(
    emit,
    () => _registrarCiudadano(
      name: event.name,
      phone: event.phone,
      password: event.password,
    ),
  );

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _cerrarSesion();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> _run(
    Emitter<AuthState> emit,
    Future<void> Function() action,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      await action();
      await _loadProfile(emit);
    } on AuthFailure catch (e) {
      emit(AuthState(status: AuthStatus.failure, error: e.message));
    } catch (_) {
      emit(
        const AuthState(
          status: AuthStatus.failure,
          error: 'Revisa tu conexión e intenta de nuevo.',
        ),
      );
    }
  }

  Future<void> _loadProfile(Emitter<AuthState> emit) async {
    final profile = await _obtenerPerfil();
    emit(AuthState(status: AuthStatus.authenticated, profile: profile));
  }
}
