import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/api_client.dart';
import '../core/storage/login_preferences.dart';
import '../core/storage/secure_storage.dart';

class AppDependencies {
  const AppDependencies({required this.overrides});

  final List<Override> overrides;
}

Future<AppDependencies> bootstrap() async {
  final secureStorage = SecureStorage();
  final sharedPreferences = await SharedPreferences.getInstance();
  final loginPreferences = LoginPreferences(sharedPreferences);
  final apiClient = ApiClient(tokenReader: secureStorage.readAccessToken);

  return AppDependencies(
    overrides: <Override>[
      secureStorageProvider.overrideWithValue(secureStorage),
      loginPreferencesProvider.overrideWithValue(loginPreferences),
      apiClientProvider.overrideWithValue(apiClient),
    ],
  );
}
