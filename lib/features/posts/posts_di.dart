import 'package:get_it/get_it.dart';

import 'package:findu/features/posts/data/supabase_posts_repository.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/posts/domain/usecases/posts_usecases.dart';
import 'package:findu/features/posts/ui/bloc/feed_bloc.dart';
import 'package:findu/features/posts/ui/bloc/post_cubit.dart';
import 'package:findu/features/publish/ui/bloc/publish_cubit.dart';

void registrarPosts(GetIt sl) {
  if (!sl.isRegistered<PostsRepository>()) {
    sl.registerLazySingleton<PostsRepository>(
      () => SupabasePostsRepository(sl()),
    );
  }

  sl
    ..registerLazySingleton(() => ObtenerFeed(sl()))
    ..registerLazySingleton(() => ObtenerMisPublicaciones(sl()))
    ..registerLazySingleton(() => ObtenerPublicacion(sl()))
    ..registerLazySingleton(() => CrearPublicacion(sl()))
    ..registerFactory(() => FeedBloc(sl()))
    ..registerFactory(() => PostCubit(sl()))
    ..registerFactory(() => MyPostsCubit(sl()))
    ..registerFactory(() => PublishCubit(sl()));
}
