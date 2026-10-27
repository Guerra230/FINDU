import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/auth/ui/screens/choose_university_screen.dart';
import 'package:findu/features/auth/ui/screens/forgot_password_screen.dart';
import 'package:findu/features/auth/ui/screens/login_screen.dart';
import 'package:findu/features/auth/ui/screens/new_password_screen.dart';
import 'package:findu/features/auth/ui/screens/recovery_code_screen.dart';
import 'package:findu/features/auth/ui/screens/register_citizen_screen.dart';
import 'package:findu/features/auth/ui/screens/register_student_screen.dart';

final Map<String, WidgetBuilder> authRoutes = {
  AppRoutes.login: (_) => const LoginScreen(),
  AppRoutes.registerStudent: (_) => const RegisterStudentScreen(),
  AppRoutes.chooseUniversity: (_) => const ChooseUniversityScreen(),
  AppRoutes.registerCitizen: (_) => const RegisterCitizenScreen(),
  AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
  AppRoutes.recoveryCode: (_) => const RecoveryCodeScreen(),
  AppRoutes.newPassword: (_) => const NewPasswordScreen(),
};
