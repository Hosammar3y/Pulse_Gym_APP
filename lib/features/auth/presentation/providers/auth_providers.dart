import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl(
      AuthRemoteDataSource(ref.watch(apiClientProvider)),
      ref.watch(secureStorageProvider),
    ));

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<AuthSession?>>((ref) {
  final controller = AuthController(ref.watch(authRepositoryProvider), ref.watch(secureStorageProvider));
  controller.restore();
  return controller;
});

class AuthController extends StateNotifier<AsyncValue<AuthSession?>> {
  AuthController(this._repository, this._storage) : super(const AsyncLoading());
  final AuthRepository _repository;
  final SecureStorage _storage;

  Future<void> restore() async {
    final token = await _storage.readAccessToken();
    if (token == null) {
      state = const AsyncData(null);
      return;
    }
    try {
      final session = await _repository.refresh();
      state = AsyncData(session.role == AuthRole.trainer ? session : null);
    } catch (_) {
      await _storage.clearAccessToken();
      state = const AsyncData(null);
    }
  }

  Future<LoginResult?> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final result = await _repository.login(email, password);
      if (result.passwordChangeRequired) {
        state = const AsyncData(null);
        return result;
      }
      final session = result.session;
      if (session == null || session.role != AuthRole.trainer) {
        await _storage.clearAccessToken();
        throw StateError('Pulse Coach mobile currently supports Trainer accounts only.');
      }
      state = AsyncData(session);
      return result;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncData(null);
  }
}
