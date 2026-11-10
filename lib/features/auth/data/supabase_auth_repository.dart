import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:findu/features/auth/domain/auth_models.dart';
import 'package:findu/features/auth/domain/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  static const _citizenDomain = 'ciudadano.findu.app';

  static String _digits(String value) => value.replaceAll(RegExp(r'\D'), '');

  static bool _isPhone(String user) =>
      !user.contains('@') && _digits(user).length >= 7;

  static String _emailFor(String user) {
    final value = user.trim().toLowerCase();
    return _isPhone(value) ? '${_digits(value)}@$_citizenDomain' : value;
  }

  @override
  bool get hasSession => _client.auth.currentSession != null;

  @override
  Future<Profile?> currentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final row = await _client
        .from('perfiles')
        .select(
          'id, nombre, correo, celular, tipo_cuenta, universidad:universidades(nombre)',
        )
        .eq('id', user.id)
        .maybeSingle();
    return row == null ? null : Profile.fromRow(row);
  }

  @override
  Future<void> signIn({required String user, required String password}) =>
      _guard(
        () => _client.auth.signInWithPassword(
          email: _emailFor(user),
          password: password,
        ),
      );

  @override
  Future<void> signUpStudent({
    required StudentDraft draft,
    required University university,
  }) => _guard(() async {
    final response = await _client.auth.signUp(
      email: draft.email.trim().toLowerCase(),
      password: draft.password,
      data: {
        'nombre': draft.name.trim(),
        'tipo_cuenta': 'universitario',
        'codigo_estudiantil': draft.code.trim(),
        'universidad_id': university.id,
        'acepto_terminos': true,
      },
    );
    if (response.session == null) {
      throw const AuthFailure(
        'Te enviamos un correo para confirmar la cuenta. Confírmala y luego ingresa.',
      );
    }
  });

  @override
  Future<void> signUpCitizen({
    required String name,
    required String phone,
    required String password,
  }) => _guard(() async {
    final response = await _client.auth.signUp(
      email: '${_digits(phone)}@$_citizenDomain',
      password: password,
      data: {
        'nombre': name.trim(),
        'tipo_cuenta': 'ciudadano',
        'celular': _digits(phone),
        'acepto_terminos': true,
      },
    );
    if (response.session == null) {
      throw const AuthFailure(
        'Desactiva "Confirm email" en Supabase para registrar ciudadanos.',
      );
    }
  });

  @override
  Future<String> sendRecoveryCode(String user) async {
    if (_isPhone(user)) {
      throw const AuthFailure(
        'La recuperación por SMS llega en el Sprint 3. Por ahora usa tu correo.',
      );
    }
    final email = _emailFor(user);
    await _guard(() => _client.auth.resetPasswordForEmail(email));
    return email;
  }

  @override
  Future<void> verifyRecoveryCode({
    required String email,
    required String code,
  }) => _guard(
    () => _client.auth.verifyOTP(
      email: email,
      token: code,
      type: OtpType.recovery,
    ),
  );

  @override
  Future<void> updatePassword(String password) =>
      _guard(() => _client.auth.updateUser(UserAttributes(password: password)));

  @override
  Future<void> signOut() => _client.auth.signOut();

  @override
  Future<List<University>> universities() async {
    final rows = await _client.from('universidades').select().order('nombre');
    return rows.map(University.fromRow).toList();
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on AuthException catch (e) {
      throw AuthFailure(_message(e));
    }
  }

  String _message(AuthException e) {
    final text = e.message.toLowerCase();
    if (text.contains('invalid login')) {
      return 'Correo, celular o contraseña incorrectos';
    }
    if (text.contains('already registered') ||
        text.contains('already been registered')) {
      return 'Ya existe una cuenta con ese correo o celular';
    }
    if (text.contains('password')) {
      return 'La contraseña debe tener mínimo 8 caracteres';
    }
    if (text.contains('expired') || text.contains('invalid')) {
      return 'El código no es válido o ya venció';
    }
    if (text.contains('rate limit')) {
      return 'Hiciste muchos intentos. Espera un momento.';
    }
    return 'No pudimos completar la operación. Intenta de nuevo.';
  }
}
