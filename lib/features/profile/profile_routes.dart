import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';

final Map<String, WidgetBuilder> profileRoutes = {
  AppRoutes.paymentMethods: (_) => const PlaceholderScreen(figma: '37', title: 'Métodos de pago'),
};
