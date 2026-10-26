import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> communitiesRoutes = {
  AppRoutes.communities: (_) => const PlaceholderScreen(figma: '30', title: 'Mis comunidades'),
  AppRoutes.joinCommunity: (_) => const PlaceholderScreen(figma: '31', title: 'Unirse a una comunidad'),
  AppRoutes.joinPending: (_) => const PlaceholderScreen(figma: '32', title: 'Solicitud enviada'),
  AppRoutes.createCommunity: (_) => const PlaceholderScreen(figma: '33', title: 'Crear comunidad'),
  AppRoutes.createSent: (_) => const PlaceholderScreen(figma: '34', title: 'Solicitud enviada'),
  AppRoutes.adminPanel: (_) => const PlaceholderScreen(figma: '35', title: 'Panel de administración'),
};
