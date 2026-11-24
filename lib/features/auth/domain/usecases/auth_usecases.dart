import 'package:findu/features/auth/domain/auth_models.dart';
import 'package:findu/features/auth/domain/auth_repository.dart';

class HaySesion {
  const HaySesion(this._repository);

  final AuthRepository _repository;

  bool call() => _repository.hasSession;
}

class ObtenerPerfilActual {
  const ObtenerPerfilActual(this._repository);

  final AuthRepository _repository;

  Future<Profile?> call() => _repository.currentProfile();
}

class IniciarSesion {
  const IniciarSesion(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String user, required String password}) {
    if (user.trim().isEmpty || password.isEmpty) {
      throw const AuthFailure('Escribe tu usuario y tu contraseña');
    }
    return _repository.signIn(user: user.trim(), password: password);
  }
}

class RegistrarUniversitario {
  const RegistrarUniversitario(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required StudentDraft draft,
    required University university,
  }) {
    if (!university.matches(draft.email)) {
      throw AuthFailure('Usa tu correo @${university.emailDomain}');
    }
    if (draft.password.length < 8) {
      throw const AuthFailure('La contraseña debe tener mínimo 8 caracteres');
    }
    return _repository.signUpStudent(draft: draft, university: university);
  }
}

class RegistrarCiudadano {
  const RegistrarCiudadano(this._repository);

  final AuthRepository _repository;

  Future<void> call({
    required String name,
    required String phone,
    required String password,
  }) {
    if (phone.replaceAll(RegExp(r'\D'), '').length != 10) {
      throw const AuthFailure('El celular debe tener 10 dígitos');
    }
    if (password.length < 8) {
      throw const AuthFailure('La contraseña debe tener mínimo 8 caracteres');
    }
    return _repository.signUpCitizen(
      name: name,
      phone: phone,
      password: password,
    );
  }
}

class CerrarSesion {
  const CerrarSesion(this._repository);

  final AuthRepository _repository;

  Future<void> call() => _repository.signOut();
}

class ObtenerUniversidades {
  const ObtenerUniversidades(this._repository);

  final AuthRepository _repository;

  Future<List<University>> call() => _repository.universities();
}

class EnviarCodigoRecuperacion {
  const EnviarCodigoRecuperacion(this._repository);

  final AuthRepository _repository;

  Future<String> call(String user) => _repository.sendRecoveryCode(user);
}

class VerificarCodigoRecuperacion {
  const VerificarCodigoRecuperacion(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email, required String code}) {
    if (code.trim().length != 6) {
      throw const AuthFailure('El código tiene 6 dígitos');
    }
    return _repository.verifyRecoveryCode(email: email, code: code.trim());
  }
}

class CambiarContrasena {
  const CambiarContrasena(this._repository);

  final AuthRepository _repository;

  Future<void> call(String password) async {
    if (password.length < 8) {
      throw const AuthFailure('La contraseña debe tener mínimo 8 caracteres');
    }
    await _repository.updatePassword(password);
    await _repository.signOut();
  }
}
