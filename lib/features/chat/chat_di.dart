import 'package:get_it/get_it.dart';

import 'package:findu/features/chat/data/supabase_chat_repository.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';
import 'package:findu/features/chat/domain/usecases/chat_usecases.dart';
import 'package:findu/features/chat/ui/bloc/chat_cubit.dart';
import 'package:findu/features/chat/ui/bloc/chats_cubit.dart';

void registrarChat(GetIt sl) {
  if (!sl.isRegistered<ChatRepository>()) {
    sl.registerLazySingleton<ChatRepository>(
      () => SupabaseChatRepository(sl()),
    );
  }

  sl
    ..registerLazySingleton(() => ObtenerConversaciones(sl()))
    ..registerLazySingleton(() => ObtenerConversacion(sl()))
    ..registerLazySingleton(() => EscucharMensajes(sl()))
    ..registerLazySingleton(() => EscucharEntrega(sl()))
    ..registerLazySingleton(() => EnviarMensaje(sl()))
    ..registerLazySingleton(() => MarcarMensajesLeidos(sl()))
    ..registerLazySingleton(() => ConfirmarEntrega(sl()))
    ..registerLazySingleton(() => ReportarProblemaEntrega(sl()))
    ..registerFactory(() => ChatsCubit(sl()))
    ..registerFactoryParam<ChatCubit, String, void>(
      (conversationId, _) => ChatCubit(
        obtenerConversacion: sl(),
        escucharMensajes: sl(),
        escucharEntrega: sl(),
        enviarMensaje: sl(),
        marcarLeidos: sl(),
        confirmarEntrega: sl(),
        conversationId: conversationId,
      ),
    )
    ..registerFactory(() => DeliveryProblemCubit(sl()));
}
