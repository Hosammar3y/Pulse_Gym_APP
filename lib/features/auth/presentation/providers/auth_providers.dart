import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/login_preferences.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';

class TemporaryPasswordChallenge {
  const TemporaryPasswordChallenge({required this.email, required this.token});
  final String email;
  final String token;
}

final temporaryPasswordChallengeProvider = StateProvider<TemporaryPasswordChallenge?>((ref) => null);

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl(
      AuthRemoteDataSource(ref.watch(apiClientProvider)),
      ref.watch(secureStorageProvider),
    ));

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<AuthSession?>>((ref) {
  final controller = AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(secureStorageProvider),
    ref.watch(loginPreferencesProvider),
    onChallenge: (challenge) => ref.read(temporaryPasswordChallengeProvider.notifier).state = challenge,
  );
  controller.restore();
  return controller;
});

class AuthController extends StateNotifier<AsyncValue<AuthSession?>> {
  AuthController(
    this._repository,
    this._storage,
    this._preferences, {
    required this.onChallenge,
  }) : super(const AsyncLoading());

  final AuthRepository _repository;
  final SecureStorage _storage;
  final LoginPreferences _preferences;
  final void Function(TemporaryPasswordChallenge? challenge) onChallenge;

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
    final normalizedEmail = email.trim().toLowerCase();
    try {
      final result = await _repository.login(normalizedEmail, password);
      await _preferences.rememberEmail(normalizedEmail);
      if (result.passwordChangeRequired) {
        final challengeToken = result.passwordChangeToken;
        if (challengeToken == null || challengeToken.isEmpty) {
          throw StateError('Temporary password challenge token is missing.');
        }
        await _storage.clearAccessToken();
        onChallenge(TemporaryPasswordChallenge(email: normalizedEmail, token: challengeToken));
        state = const AsyncData(null);
        return result;
      }
      onChallenge(null);
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

  Future<bool> completeTemporaryPassword(TemporaryPasswordChallenge challenge, String newPassword) async {
    state = const AsyncLoading();
    try {
      await _repository.completeTemporaryPassword(challenge.token, newPassword);
      await _preferences.rememberEmail(challenge.email);
      await _storage.clearAccessToken();
      onChallenge(null);
      state = const AsyncData(null);
      return true;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    onChallenge(null);
    state = const AsyncData(null);
  }
}
