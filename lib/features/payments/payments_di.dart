import 'package:get_it/get_it.dart';

import 'package:findu/features/payments/data/supabase_payments_repository.dart';
import 'package:findu/features/payments/domain/payments_repository.dart';
import 'package:findu/features/payments/domain/usecases/payments_usecases.dart';
import 'package:findu/features/payments/ui/bloc/boost_cubit.dart';
import 'package:findu/features/payments/ui/bloc/payment_methods_cubit.dart';

void registrarPagos(GetIt sl) {
  if (!sl.isRegistered<PaymentsRepository>()) {
    sl.registerLazySingleton<PaymentsRepository>(
      () => SupabasePaymentsRepository(sl()),
    );
  }

  sl
    ..registerLazySingleton(() => ObtenerPlanesImpulso(sl()))
    ..registerLazySingleton(() => ObtenerMetodosPago(sl()))
    ..registerLazySingleton(() => AgregarMetodoPago(sl()))
    ..registerLazySingleton(() => ElegirMetodoPredeterminado(sl()))
    ..registerLazySingleton(() => ImpulsarPublicacion(sl()))
    ..registerFactoryParam<BoostCubit, String, void>(
      (postId, _) => BoostCubit(
        obtenerPlanes: sl(),
        obtenerMetodos: sl(),
        impulsar: sl(),
        postId: postId,
      ),
    )
    ..registerFactory(
      () => PaymentMethodsCubit(
        obtenerMetodos: sl(),
        agregarMetodo: sl(),
        elegirPredeterminado: sl(),
      ),
    );
}
