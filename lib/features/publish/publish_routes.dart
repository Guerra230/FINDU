import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/publish/ui/screens/boost_active_screen.dart';
import 'package:findu/features/publish/ui/screens/boost_screen.dart';
import 'package:findu/features/publish/ui/screens/publish_object_screen.dart';
import 'package:findu/features/publish/ui/screens/publish_pet_screen.dart';
import 'package:findu/features/publish/ui/screens/published_screen.dart';
import 'package:findu/features/publish/ui/screens/share_report_screen.dart';

final Map<String, WidgetBuilder> publishRoutes = {
  AppRoutes.publishObject: (_) => const PublishObjectScreen(),
  AppRoutes.publishPet: (_) => const PublishPetScreen(),
  AppRoutes.published: (_) => const PublishedScreen(),
  AppRoutes.shareReport: (_) => const ShareReportScreen(),
  AppRoutes.boost: (_) => const BoostScreen(),
  AppRoutes.boostActive: (_) => const BoostActiveScreen(),
};
