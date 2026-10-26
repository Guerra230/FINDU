import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:findu/core/design_system/design_system.dart';
import 'package:findu/core/navigation/app_router.dart';
import 'package:findu/core/navigation/app_routes.dart';

class FinduApp extends StatelessWidget {
  const FinduApp({super.key});

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
      initialRoute: AppRoutes.login,
      routes: AppRouter.routes,
      onUnknownRoute: AppRouter.unknown,
    );
  }
}
