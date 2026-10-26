import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> notificationsRoutes = {
  AppRoutes.notifications: (_) => const PlaceholderScreen(figma: '11', title: 'Notificaciones'),
  AppRoutes.alertSettings: (_) => const PlaceholderScreen(figma: '12', title: 'Configurar alertas'),
};
