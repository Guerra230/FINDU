class DemoCommunity {
  const DemoCommunity({
    required this.name,
    required this.type,
    required this.members,
    required this.isAdmin,
  });

  final String name;
  final String type;
  final int members;
  final bool isAdmin;
}

class DemoBoostPlan {
  const DemoBoostPlan({
    required this.name,
    required this.price,
    required this.radiusKm,
    required this.people,
    required this.hours,
  });

  final String name;
  final int price;
  final int radiusKm;
  final int people;
  final int hours;
}

abstract final class DemoData {
  static const communities = <DemoCommunity>[
    DemoCommunity(
      name: 'Universidad Icesi',
      type: 'Educativa',
      members: 1500,
      isAdmin: false,
    ),
    DemoCommunity(
      name: 'Conjunto Bosques de Lili',
      type: 'Residencial',
      members: 124,
      isAdmin: true,
    ),
  ];

  static const accessCode = 'LILI-4821';

  static const boostPlans = <DemoBoostPlan>[
    DemoBoostPlan(
      name: 'Básico',
      price: 5000,
      radiusKm: 3,
      people: 200,
      hours: 24,
    ),
    DemoBoostPlan(
      name: 'Destacado',
      price: 8000,
      radiusKm: 8,
      people: 1200,
      hours: 72,
    ),
  ];
}
