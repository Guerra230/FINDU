import 'package:findu/features/payments/domain/payments_models.dart';
import 'package:findu/features/payments/domain/payments_repository.dart';

class ObtenerPlanesImpulso {
  const ObtenerPlanesImpulso(this._repository);

  final PaymentsRepository _repository;

  Future<List<BoostPlan>> call() async {
    final plans = await _repository.plans();
    return plans..sort((a, b) => a.price.compareTo(b.price));
  }
}

class ObtenerMetodosPago {
  const ObtenerMetodosPago(this._repository);

  final PaymentsRepository _repository;

  Future<List<PaymentMethod>> call() async {
    final methods = await _repository.methods();
    return methods
      ..sort((a, b) => (b.isDefault ? 1 : 0) - (a.isDefault ? 1 : 0));
  }
}

class AgregarMetodoPago {
  const AgregarMetodoPago(this._repository);

  final PaymentsRepository _repository;

  Future<void> call(PaymentProvider provider, String last4) {
    if (!RegExp(r'^\d{4}$').hasMatch(last4.trim())) {
      throw const PaymentFailure('Escribe los últimos 4 dígitos');
    }
    return _repository.addMethod(provider, last4.trim());
  }
}

class ElegirMetodoPredeterminado {
  const ElegirMetodoPredeterminado(this._repository);

  final PaymentsRepository _repository;

  Future<void> call(PaymentMethod method) async {
    if (method.isDefault) return;
    await _repository.setDefault(method.id);
  }
}

class ImpulsarPublicacion {
  const ImpulsarPublicacion(this._repository);

  final PaymentsRepository _repository;

  Future<BoostResult> call({
    required String postId,
    required BoostPlan plan,
    PaymentMethod? method,
  }) async {
    final provider = method?.provider ?? PaymentProvider.nequi;
    final endsAt = await _repository.boost(
      postId: postId,
      planId: plan.id,
      provider: provider,
    );
    return BoostResult(
      plan: plan,
      endsAt: endsAt,
      method: method?.label ?? 'Nequi',
    );
  }
}
