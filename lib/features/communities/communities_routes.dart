import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/communities/ui/screens/admin_panel_screen.dart';
import 'package:findu/features/communities/ui/screens/communities_screen.dart';
import 'package:findu/features/communities/ui/screens/create_community_screen.dart';
import 'package:findu/features/communities/ui/screens/create_sent_screen.dart';
import 'package:findu/features/communities/ui/screens/join_community_screen.dart';
import 'package:findu/features/communities/ui/screens/join_pending_screen.dart';

final Map<String, WidgetBuilder> communitiesRoutes = {
  AppRoutes.communities: (_) => const CommunitiesScreen(),
  AppRoutes.joinCommunity: (_) => const JoinCommunityScreen(),
  AppRoutes.joinPending: (_) => const JoinPendingScreen(),
  AppRoutes.createCommunity: (_) => const CreateCommunityScreen(),
  AppRoutes.createSent: (_) => const CreateSentScreen(),
  AppRoutes.adminPanel: (_) => const AdminPanelScreen(),
};
