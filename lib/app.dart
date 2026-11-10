import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_router.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/supabase/supabase_setup.dart';
import 'package:findu/features/auth/data/supabase_auth_repository.dart';
import 'package:findu/features/auth/domain/auth_repository.dart';
import 'package:findu/features/auth/ui/bloc/auth_bloc.dart';
import 'package:findu/features/chat/data/supabase_chat_repository.dart';
import 'package:findu/features/chat/domain/chat_repository.dart';
import 'package:findu/features/notifications/data/supabase_notifications_repository.dart';
import 'package:findu/features/notifications/domain/notifications_repository.dart';
import 'package:findu/features/posts/data/supabase_posts_repository.dart';
import 'package:findu/features/posts/domain/posts_repository.dart';
import 'package:findu/features/verification/data/supabase_verification_repository.dart';
import 'package:findu/features/verification/domain/verification_repository.dart';

class FinduApp extends StatelessWidget {
  const FinduApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = SupabaseSetup.client;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => SupabaseAuthRepository(client),
        ),
        RepositoryProvider<PostsRepository>(
          create: (_) => SupabasePostsRepository(client),
        ),
        RepositoryProvider<VerificationRepository>(
          create: (_) => SupabaseVerificationRepository(client),
        ),
        RepositoryProvider<ChatRepository>(
          create: (_) => SupabaseChatRepository(client),
        ),
        RepositoryProvider<NotificationsRepository>(
          create: (_) => SupabaseNotificationsRepository(client),
        ),
      ],
      child: BlocProvider(
        create: (context) =>
            AuthBloc(context.read<AuthRepository>())..add(const AuthStarted()),
        child: _FinduMaterialApp(
          initialRoute: client.auth.currentSession == null
              ? AppRoutes.login
              : AppRoutes.main,
        ),
      ),
    );
  }
}

class _FinduMaterialApp extends StatelessWidget {
  const _FinduMaterialApp({required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FINDU',
      debugShowCheckedModeBanner: false,
      theme: FdTheme.light,
      themeMode: ThemeMode.light,
      locale: const Locale('es'),
      supportedLocales: const [Locale('es'), Locale('en')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      initialRoute: initialRoute,
      routes: AppRouter.routes,
      onUnknownRoute: AppRouter.unknown,
    );
  }
}

class MissingConfigApp extends StatelessWidget {
  const MissingConfigApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FdTheme.light,
      home: const FdScaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(FdSpacing.screen),
            child: FdEmptyState(
              mood: FdMood.triste,
              title: 'Falta configurar Supabase',
              message:
                  'Copia env.example.json como env.json, pon tu URL y tu anon key, y corre:\n'
                  'flutter run --dart-define-from-file=env.json',
            ),
          ),
        ),
      ),
    );
  }
}
