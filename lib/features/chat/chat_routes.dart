import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/chat/ui/screens/chat_screen.dart';
import 'package:findu/features/chat/ui/screens/delivery_problem_screen.dart';
import 'package:findu/features/chat/ui/screens/delivery_verified_screen.dart';
import 'package:findu/features/chat/ui/screens/problem_sent_screen.dart';

final Map<String, WidgetBuilder> chatRoutes = {
  AppRoutes.chat: (_) => const ChatScreen(),
  AppRoutes.deliveryProblem: (_) => const DeliveryProblemScreen(),
  AppRoutes.problemSent: (_) => const ProblemSentScreen(),
  AppRoutes.deliveryVerified: (_) => const DeliveryVerifiedScreen(),
};
