import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> authRoutes = {
  AppRoutes.login: (_) => const PlaceholderScreen(figma: '01', title: 'Ingresar', showBack: false),
  AppRoutes.registerStudent: (_) => const PlaceholderScreen(figma: '02', title: 'Crear cuenta'),
  AppRoutes.chooseUniversity: (_) => const PlaceholderScreen(figma: '03', title: 'Elige tu universidad'),
  AppRoutes.registerCitizen: (_) => const PlaceholderScreen(figma: '04', title: 'Crear cuenta'),
  AppRoutes.forgotPassword: (_) => const PlaceholderScreen(figma: '05', title: 'Recuperar contraseña'),
  AppRoutes.recoveryCode: (_) => const PlaceholderScreen(figma: '06', title: 'Recuperar contraseña'),
  AppRoutes.newPassword: (_) => const PlaceholderScreen(figma: '07', title: 'Nueva contraseña'),
};
