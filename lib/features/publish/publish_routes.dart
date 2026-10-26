import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> publishRoutes = {
  AppRoutes.publishObject: (_) => const PlaceholderScreen(figma: '13', title: 'Publicar objeto'),
  AppRoutes.publishPet: (_) => const PlaceholderScreen(figma: '14', title: 'Reportar mascota'),
  AppRoutes.published: (_) => const PlaceholderScreen(figma: '15', title: 'Publicación lista'),
  AppRoutes.shareReport: (_) => const PlaceholderScreen(figma: '16', title: 'Compartir reporte'),
  AppRoutes.boost: (_) => const PlaceholderScreen(figma: '17', title: 'Impulsar publicación'),
  AppRoutes.boostActive: (_) => const PlaceholderScreen(figma: '18', title: 'Impulso activo'),
};
