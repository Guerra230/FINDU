import 'package:get_it/get_it.dart';

import 'package:findu/features/notifications/data/supabase_notifications_repository.dart';
import 'package:findu/features/notifications/domain/notifications_repository.dart';
import 'package:findu/features/notifications/domain/usecases/notifications_usecases.dart';
import 'package:findu/features/notifications/ui/bloc/notifications_cubit.dart';

void registrarNotificaciones(GetIt sl) {
  if (!sl.isRegistered<NotificationsRepository>()) {
    sl.registerLazySingleton<NotificationsRepository>(
      () => SupabaseNotificationsRepository(sl()),
    );
  }

  sl
    ..registerLazySingleton(() => ObtenerNotificaciones(sl()))
    ..registerLazySingleton(() => MarcarNotificacionLeida(sl()))
    ..registerLazySingleton(() => MarcarTodasLeidas(sl()))
    ..registerFactory(
      () => NotificationsCubit(
        obtenerNotificaciones: sl(),
        marcarLeida: sl(),
        marcarTodas: sl(),
      ),
    );
}
