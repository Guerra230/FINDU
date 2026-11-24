import 'package:get_it/get_it.dart';

import 'package:findu/features/auth/data/supabase_auth_repository.dart';
import 'package:findu/features/auth/domain/auth_repository.dart';
import 'package:findu/features/auth/domain/usecases/auth_usecases.dart';
import 'package:findu/features/auth/ui/bloc/auth_bloc.dart';
import 'package:findu/features/auth/ui/bloc/recovery_cubit.dart';
import 'package:findu/features/auth/ui/bloc/universities_cubit.dart';

void registrarAuth(GetIt sl) {
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => SupabaseAuthRepository(sl()),
    );
  }

  sl
    ..registerLazySingleton(() => HaySesion(sl()))
    ..registerLazySingleton(() => ObtenerPerfilActual(sl()))
    ..registerLazySingleton(() => IniciarSesion(sl()))
    ..registerLazySingleton(() => RegistrarUniversitario(sl()))
    ..registerLazySingleton(() => RegistrarCiudadano(sl()))
    ..registerLazySingleton(() => CerrarSesion(sl()))
    ..registerLazySingleton(() => ObtenerUniversidades(sl()))
    ..registerLazySingleton(() => EnviarCodigoRecuperacion(sl()))
    ..registerLazySingleton(() => VerificarCodigoRecuperacion(sl()))
    ..registerLazySingleton(() => CambiarContrasena(sl()))
    ..registerLazySingleton(
      () => AuthBloc(
        haySesion: sl(),
        obtenerPerfil: sl(),
        iniciarSesion: sl(),
        registrarUniversitario: sl(),
        registrarCiudadano: sl(),
        cerrarSesion: sl(),
      ),
    )
    ..registerFactory(() => UniversitiesCubit(sl()))
    ..registerFactory(
      () => RecoveryCubit(
        enviarCodigo: sl(),
        verificarCodigo: sl(),
        cambiarContrasena: sl(),
      ),
    );
}
