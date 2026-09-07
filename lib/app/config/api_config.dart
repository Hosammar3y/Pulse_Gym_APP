import 'environment.dart';

class ApiConfig {
  const ApiConfig({required this.baseUrl});

  final String baseUrl;

  factory ApiConfig.forEnvironment(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.development => const ApiConfig(baseUrl: 'http://10.0.2.2:8080/api'),
      AppEnvironment.staging => const ApiConfig(baseUrl: 'https://staging.example.com/api'),
      AppEnvironment.production => const ApiConfig(baseUrl: 'https://api.example.com/api'),
    };
  }
}
