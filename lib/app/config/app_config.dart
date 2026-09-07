import 'api_config.dart';
import 'environment.dart';

class AppConfig {
  const AppConfig({required this.environment, required this.api});

  final AppEnvironment environment;
  final ApiConfig api;

  factory AppConfig.current() {
    const raw = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    final environment = switch (raw) {
      'production' => AppEnvironment.production,
      'staging' => AppEnvironment.staging,
      _ => AppEnvironment.development,
    };

    return AppConfig(
      environment: environment,
      api: ApiConfig.forEnvironment(environment),
    );
  }
}
