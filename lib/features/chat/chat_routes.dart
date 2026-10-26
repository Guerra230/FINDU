import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> chatRoutes = {
  AppRoutes.chat: (_) => const PlaceholderScreen(figma: '26 · S1', title: 'Chat'),
  AppRoutes.deliveryProblem: (_) => const PlaceholderScreen(figma: '27', title: 'Reportar problema'),
  AppRoutes.problemSent: (_) => const PlaceholderScreen(figma: '28', title: 'Reporte enviado'),
  AppRoutes.deliveryVerified: (_) => const PlaceholderScreen(figma: '29', title: 'Entrega verificada'),
};
