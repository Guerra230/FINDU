class BoostPlan {
  const BoostPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.radiusKm,
    required this.people,
    required this.hours,
  });

  factory BoostPlan.fromRow(Map<String, dynamic> row) => BoostPlan(
    id: row['id'] as String,
    name: row['nombre'] as String,
    price: (row['precio_cop'] as num).toInt(),
    radiusKm: (row['radio_km'] as num).toInt(),
    people: (row['alcance_personas'] as num).toInt(),
    hours: (row['duracion_horas'] as num).toInt(),
  );

  final String id;
  final String name;
  final int price;
  final int radiusKm;
  final int people;
  final int hours;
}

enum PaymentProvider { nequi, card }

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.provider,
    required this.last4,
    required this.isDefault,
  });

  factory PaymentMethod.fromRow(Map<String, dynamic> row) => PaymentMethod(
    id: row['id'] as String,
    provider: row['proveedor'] == 'tarjeta'
        ? PaymentProvider.card
        : PaymentProvider.nequi,
    last4: row['ultimos4'] as String,
    isDefault: row['predeterminado'] == true,
  );

  final String id;
  final PaymentProvider provider;
  final String last4;
  final bool isDefault;

  String get providerName =>
      provider == PaymentProvider.card ? 'Tarjeta' : 'Nequi';

  String get label => '$providerName ····$last4';
}

class BoostResult {
  const BoostResult({
    required this.plan,
    required this.endsAt,
    required this.method,
  });

  final BoostPlan plan;
  final DateTime endsAt;
  final String method;
}

class PaymentFailure implements Exception {
  const PaymentFailure(this.message);

  final String message;
}
