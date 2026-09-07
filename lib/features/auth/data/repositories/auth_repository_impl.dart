import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._storage);
  final AuthRemoteDataSource _remote;
  final SecureStorage _storage;

  @override
  Future<LoginResult> login(String email, String password) async {
    final result = LoginResultModel(await _remote.login(email, password)).toDomain();
    final token = result.session?.accessToken;
    if (token != null) await _storage.writeAccessToken(token);
    return result;
  }

  @override
  Future<AuthSession> refresh() async {
    final session = AuthSessionModel(await _remote.refresh()).toDomain();
    await _storage.writeAccessToken(session.accessToken);
    return session;
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } finally {
      await _storage.clearAccessToken();
    }
  }

  @override
  Future<TrainerProfile> trainerProfile() async =>
      TrainerProfileModel(await _remote.trainerProfile()).toDomain();
}
