import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final loginPreferencesProvider = Provider<LoginPreferences>(
  (ref) => throw UnimplementedError('LoginPreferences is provided during bootstrap.'),
);

class LoginPreferences {
  LoginPreferences(this._preferences);

  static const _lastLoginEmailKey = 'pulse_coach_last_login_email';
  final SharedPreferences _preferences;

  String? readLastLoginEmail() => _preferences.getString(_lastLoginEmailKey);

  Future<void> rememberEmail(String email) async {
    final normalized = email.trim().toLowerCase();
    if (normalized.isEmpty) return;
    await _preferences.setString(_lastLoginEmailKey, normalized);
  }
}
