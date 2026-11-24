import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:findu/core/supabase/supabase_setup.dart';
import 'package:findu/features/auth/auth_di.dart';
import 'package:findu/features/chat/chat_di.dart';
import 'package:findu/features/communities/communities_di.dart';
import 'package:findu/features/notifications/notifications_di.dart';
import 'package:findu/features/payments/payments_di.dart';
import 'package:findu/features/posts/posts_di.dart';
import 'package:findu/features/verification/verification_di.dart';

final sl = GetIt.instance;

void configurarDependencias() {
  if (!sl.isRegistered<SupabaseClient>()) {
    sl.registerLazySingleton<SupabaseClient>(() => SupabaseSetup.client);
  }
  registrarAuth(sl);
  registrarPosts(sl);
  registrarVerificacion(sl);
  registrarChat(sl);
  registrarNotificaciones(sl);
  registrarComunidades(sl);
  registrarPagos(sl);
}
