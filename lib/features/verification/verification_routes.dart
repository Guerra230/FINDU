import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/verification/ui/screens/found_report_screen.dart';
import 'package:findu/features/verification/ui/screens/verification_approved_screen.dart';
import 'package:findu/features/verification/ui/screens/verification_failed_screen.dart';
import 'package:findu/features/verification/ui/screens/verification_intro_screen.dart';
import 'package:findu/features/verification/ui/screens/verification_question_screen.dart';

final Map<String, WidgetBuilder> verificationRoutes = {
  AppRoutes.verificationIntro: (_) => const VerificationIntroScreen(),
  AppRoutes.verificationQuestion: (_) => const VerificationQuestionScreen(),
  AppRoutes.verificationApproved: (_) => const VerificationApprovedScreen(),
  AppRoutes.verificationFailed: (_) => const VerificationFailedScreen(),
  AppRoutes.foundReport: (_) => const FoundReportScreen(),
};
