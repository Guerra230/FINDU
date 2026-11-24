import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_router.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/di/inyeccion.dart';
import 'package:findu/features/auth/domain/usecases/auth_usecases.dart';
import 'package:findu/features/auth/ui/bloc/auth_bloc.dart';

class FinduApp extends StatelessWidget {
  const FinduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => sl<AuthBloc>()..add(const AuthStarted()),
      child: _FinduMaterialApp(
        initialRoute: sl<HaySesion>()() ? AppRoutes.main : AppRoutes.login,
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
