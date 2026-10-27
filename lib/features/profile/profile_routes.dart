import 'package:flutter/widgets.dart';

import 'package:findu/core/navigation/app_routes.dart';
import 'package:findu/features/profile/ui/screens/payment_methods_screen.dart';

final Map<String, WidgetBuilder> profileRoutes = {
  AppRoutes.paymentMethods: (_) => const PaymentMethodsScreen(),
};
