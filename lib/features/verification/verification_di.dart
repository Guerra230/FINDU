import 'package:get_it/get_it.dart';

import 'package:findu/features/verification/data/supabase_verification_repository.dart';
import 'package:findu/features/verification/domain/usecases/verification_usecases.dart';
import 'package:findu/features/verification/domain/verification_repository.dart';
import 'package:findu/features/verification/ui/bloc/found_report_cubit.dart';
import 'package:findu/features/verification/ui/bloc/verification_cubit.dart';

void registrarVerificacion(GetIt sl) {
  if (!sl.isRegistered<VerificationRepository>()) {
    sl.registerLazySingleton<VerificationRepository>(
      () => SupabaseVerificationRepository(sl()),
    );
  }

  sl
    ..registerLazySingleton(() => ObtenerPreguntas(sl()))
    ..registerLazySingleton(() => VerificarRespuestas(sl()))
    ..registerLazySingleton(() => ReportarHallazgo(sl()))
    ..registerFactoryParam<VerificationCubit, String, void>(
      (postId, _) => VerificationCubit(
        obtenerPreguntas: sl(),
        verificarRespuestas: sl(),
        postId: postId,
      ),
    )
    ..registerFactory(() => FoundReportCubit(sl()));
}
