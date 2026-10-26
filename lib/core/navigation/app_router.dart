import 'package:flutter/material.dart';

import 'package:findu/core/design_system/gallery/design_system_gallery.dart';
import 'package:findu/core/dev/dev_menu_screen.dart';
import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/core/navigation/main_shell.dart';
import 'package:findu/core/navigation/placeholder_screen.dart';
import 'package:findu/features/auth/auth_routes.dart';
import 'package:findu/features/chat/chat_routes.dart';
import 'package:findu/features/communities/communities_routes.dart';
import 'package:findu/features/explore/explore_routes.dart';
import 'package:findu/features/notifications/notifications_routes.dart';
import 'package:findu/features/posts/posts_routes.dart';
import 'package:findu/features/profile/profile_routes.dart';
import 'package:findu/features/publish/publish_routes.dart';
import 'package:findu/features/verification/verification_routes.dart';

abstract final class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    ...authRoutes,
    AppRoutes.main: (context) {
      final tab = ModalRoute.of(context)?.settings.arguments;
      return MainShell(initialTab: tab is int ? tab : AppTabs.home);
    },
    ...exploreRoutes,
    ...notificationsRoutes,
    ...publishRoutes,
    ...postsRoutes,
    ...verificationRoutes,
    ...chatRoutes,
    ...communitiesRoutes,
    ...profileRoutes,
    AppRoutes.devMenu: (_) => const DevMenuScreen(),
    AppRoutes.designSystem: (_) => const DesignSystemGallery(),
  };

  static Route<void> unknown(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => PlaceholderScreen(figma: '?', title: settings.name ?? 'Ruta no encontrada'),
    );
  }
}
