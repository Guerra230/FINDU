import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/explore/ui/screens/map_screen.dart';

final Map<String, WidgetBuilder> exploreRoutes = {
  AppRoutes.map: (_) => const MapScreen(),
};
