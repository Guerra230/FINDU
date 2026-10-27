import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/notifications/ui/screens/alert_settings_screen.dart';
import 'package:findu/features/notifications/ui/screens/notifications_screen.dart';

final Map<String, WidgetBuilder> notificationsRoutes = {
  AppRoutes.notifications: (_) => const NotificationsScreen(),
  AppRoutes.alertSettings: (_) => const AlertSettingsScreen(),
};
