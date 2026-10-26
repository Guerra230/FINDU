import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> exploreRoutes = {
  AppRoutes.map: (_) => const PlaceholderScreen(figma: '10', title: 'Mapa'),
};
