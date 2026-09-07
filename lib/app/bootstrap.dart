import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
import '../core/storage/secure_storage.dart';

class AppDependencies {
  const AppDependencies({required this.overrides});

  final List<Override> overrides;
}

Future<AppDependencies> bootstrap() async {
  final secureStorage = SecureStorage();
  final apiClient = ApiClient(tokenReader: secureStorage.readAccessToken);

  return AppDependencies(
    overrides: <Override>[
      secureStorageProvider.overrideWithValue(secureStorage),
      apiClientProvider.overrideWithValue(apiClient),
    ],
  );
}
