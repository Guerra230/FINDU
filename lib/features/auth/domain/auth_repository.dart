import 'package:findu/features/auth/domain/auth_models.dart';

abstract interface class AuthRepository {
  bool get hasSession;

  Future<Profile?> currentProfile();

  Future<void> signIn({required String user, required String password});

  Future<void> signUpStudent({
    required StudentDraft draft,
    required University university,
  });

  Future<void> signUpCitizen({
    required String name,
    required String phone,
    required String password,
  });

  Future<String> sendRecoveryCode(String user);

  Future<void> verifyRecoveryCode({
    required String email,
    required String code,
  });

  Future<void> updatePassword(String password);

  Future<void> signOut();

  Future<List<University>> universities();
}
