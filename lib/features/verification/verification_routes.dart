import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> verificationRoutes = {
  AppRoutes.verificationIntro: (_) => const PlaceholderScreen(figma: '20', title: 'Verificación'),
  AppRoutes.verificationQuestion: (_) => const PlaceholderScreen(figma: '21', title: 'Verificación'),
  AppRoutes.verificationApproved: (_) => const PlaceholderScreen(figma: '22', title: '¡Es tuya!'),
  AppRoutes.verificationFailed: (_) => const PlaceholderScreen(figma: '23', title: 'No coincide'),
  AppRoutes.foundReport: (_) => const PlaceholderScreen(figma: '24', title: 'Encontré a…'),
};
