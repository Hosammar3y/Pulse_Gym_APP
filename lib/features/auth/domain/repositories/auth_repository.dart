import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<LoginResult> login(String email, String password);
  Future<AuthSession> refresh();
  Future<void> logout();
  Future<TrainerProfile> trainerProfile();
}
