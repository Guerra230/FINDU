class University {
  const University({
    required this.id,
    required this.name,
    required this.emailDomain,
    required this.city,
  });

  final String id;
  final String name;
  final String emailDomain;
  final String city;

  bool matches(String email) =>
      email.trim().toLowerCase().endsWith('@$emailDomain');

  factory University.fromRow(Map<String, dynamic> row) => University(
    id: row['id'] as String,
    name: row['nombre'] as String,
    emailDomain: row['dominio_correo'] as String,
    city: row['ciudad'] as String? ?? 'Cali',
  );
}

class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.isStudent,
    this.email,
    this.phone,
    this.universityName,
  });

  final String id;
  final String name;
  final bool isStudent;
  final String? email;
  final String? phone;
  final String? universityName;

  factory Profile.fromRow(Map<String, dynamic> row) {
    final university = row['universidad'];
    return Profile(
      id: row['id'] as String,
      name: row['nombre'] as String,
      isStudent: row['tipo_cuenta'] == 'universitario',
      email: row['correo'] as String?,
      phone: row['celular'] as String?,
      universityName: university is Map<String, dynamic>
          ? university['nombre'] as String?
          : null,
    );
  }
}

class StudentDraft {
  const StudentDraft({
    required this.name,
    required this.email,
    required this.code,
    required this.password,
  });

  final String name;
  final String email;
  final String code;
  final String password;
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
