import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) => throw UnimplementedError('SecureStorage is provided during bootstrap.'));

class SecureStorage {
  SecureStorage({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  static const _accessTokenKey = 'pulse_access_token';
  final FlutterSecureStorage _storage;

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);
  Future<void> writeAccessToken(String token) => _storage.write(key: _accessTokenKey, value: token);
  Future<void> clearAccessToken() => _storage.delete(key: _accessTokenKey);
}
