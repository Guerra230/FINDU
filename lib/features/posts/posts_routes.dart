import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> postsRoutes = {
  AppRoutes.postDetail: (_) => const PlaceholderScreen(figma: '19', title: 'Detalle'),
};
