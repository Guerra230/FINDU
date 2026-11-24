import 'package:get_it/get_it.dart';

import 'package:findu/features/communities/data/supabase_communities_repository.dart';
import 'package:findu/features/communities/domain/communities_repository.dart';
import 'package:findu/features/communities/domain/usecases/communities_usecases.dart';
import 'package:findu/features/communities/ui/bloc/admin_panel_cubit.dart';
import 'package:findu/features/communities/ui/bloc/communities_cubit.dart';
import 'package:findu/features/communities/ui/bloc/community_form_cubit.dart';

void registrarComunidades(GetIt sl) {
  if (!sl.isRegistered<CommunitiesRepository>()) {
    sl.registerLazySingleton<CommunitiesRepository>(
      () => SupabaseCommunitiesRepository(sl()),
    );
  }

  sl
    ..registerLazySingleton(() => ObtenerMisComunidades(sl()))
    ..registerLazySingleton(() => CrearComunidad(sl()))
    ..registerLazySingleton(() => UnirseConCodigo(sl()))
    ..registerLazySingleton(() => SolicitarIngreso(sl()))
    ..registerLazySingleton(() => ActivarComunidad(sl()))
    ..registerLazySingleton(() => ObtenerPanelAdmin(sl()))
    ..registerLazySingleton(() => GenerarCodigo(sl()))
    ..registerLazySingleton(() => ResolverSolicitud(sl()))
    ..registerFactory(
      () =>
          CommunitiesCubit(obtenerMisComunidades: sl(), activarComunidad: sl()),
    )
    ..registerFactory(
      () => JoinCommunityCubit(unirseConCodigo: sl(), solicitarIngreso: sl()),
    )
    ..registerFactory(() => CreateCommunityCubit(sl()))
    ..registerFactoryParam<AdminPanelCubit, String, void>(
      (communityId, _) => AdminPanelCubit(
        obtenerPanel: sl(),
        generarCodigo: sl(),
        resolverSolicitud: sl(),
        communityId: communityId,
      ),
    );
}
