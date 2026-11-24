class Community {
  const Community({
    required this.id,
    required this.name,
    required this.type,
    required this.members,
    required this.isAdmin,
    required this.isActive,
    required this.isPending,
  });

  factory Community.fromRow(Map<String, dynamic> row) => Community(
    id: row['id'] as String,
    name: row['nombre'] as String,
    type: communityTypeLabel(row['tipo'] as String?),
    members: (row['miembros'] as num?)?.toInt() ?? 0,
    isAdmin: row['rol'] == 'admin',
    isActive: row['es_activa'] == true,
    isPending: row['estado'] == 'pendiente',
  );

  final String id;
  final String name;
  final String type;
  final int members;
  final bool isAdmin;
  final bool isActive;
  final bool isPending;
}

class JoinRequest {
  const JoinRequest({
    required this.id,
    required this.name,
    required this.requestedAt,
  });

  factory JoinRequest.fromJson(Map<String, dynamic> json) => JoinRequest(
    id: json['id'] as String,
    name: json['nombre'] as String? ?? 'Usuario',
    requestedAt: DateTime.parse(json['solicitado_en'] as String),
  );

  final String id;
  final String name;
  final DateTime requestedAt;
}

class AdminPanel {
  const AdminPanel({
    required this.code,
    required this.uses,
    required this.maxUses,
    required this.requests,
    this.expiresAt,
  });

  factory AdminPanel.fromJson(Map<String, dynamic> json) => AdminPanel(
    code: json['codigo'] as String? ?? '',
    uses: (json['usos'] as num?)?.toInt() ?? 0,
    maxUses: (json['usos_maximos'] as num?)?.toInt() ?? 20,
    expiresAt: json['vence_en'] == null
        ? null
        : DateTime.parse(json['vence_en'] as String),
    requests: [
      for (final r in (json['solicitudes'] as List? ?? const []))
        JoinRequest.fromJson(r as Map<String, dynamic>),
    ],
  );

  final String code;
  final int uses;
  final int maxUses;
  final DateTime? expiresAt;
  final List<JoinRequest> requests;

  AdminPanel copyWith({String? code, int? uses, List<JoinRequest>? requests}) =>
      AdminPanel(
        code: code ?? this.code,
        uses: uses ?? this.uses,
        maxUses: maxUses,
        expiresAt: expiresAt,
        requests: requests ?? this.requests,
      );
}

class NewCommunity {
  const NewCommunity({
    required this.name,
    required this.type,
    required this.address,
  });

  final String name;
  final String type;
  final String address;
}

class CommunityFailure implements Exception {
  const CommunityFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

const communityTypes = {
  'Educativa': 'educativa',
  'Residencial': 'residencial',
  'Corporativa': 'corporativa',
  'Pública': 'publica',
  'Evento temporal': 'evento',
};

String communityTypeLabel(String? value) => communityTypes.entries
    .firstWhere(
      (e) => e.value == value,
      orElse: () => const MapEntry('Comunidad', ''),
    )
    .key;
