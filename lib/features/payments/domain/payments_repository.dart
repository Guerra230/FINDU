import 'package:findu/features/payments/domain/payments_models.dart';

abstract interface class PaymentsRepository {
  Future<List<BoostPlan>> plans();

  Future<List<PaymentMethod>> methods();

  Future<void> addMethod(PaymentProvider provider, String last4);

  Future<void> setDefault(String methodId);

  Future<DateTime> boost({
    required String postId,
    required String planId,
    required PaymentProvider provider,
  });
}
