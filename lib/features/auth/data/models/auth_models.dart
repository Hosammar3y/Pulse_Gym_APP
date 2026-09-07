import '../../domain/entities/auth_session.dart';

AuthRole _role(String value) => switch (value) {
      'ADMIN' => AuthRole.admin,
      'TRAINER' => AuthRole.trainer,
      'TRAINEE' => AuthRole.trainee,
      _ => throw FormatException('Unsupported auth role: $value'),
    };

class LoginResultModel {
  const LoginResultModel(this.json);
  final Map<String, dynamic> json;

  LoginResult toDomain() {
    final role = _role(json['role'] as String);
    final token = json['accessToken'] as String?;
    return LoginResult(
      role: role,
      userId: json['userId'] as String,
      passwordChangeRequired: json['passwordChangeRequired'] as bool? ?? false,
      passwordChangeToken: json['passwordChangeToken'] as String?,
      session: token == null
          ? null
          : AuthSession(
              accessToken: token,
              tokenType: json['tokenType'] as String? ?? 'Bearer',
              expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 0,
              role: role,
              userId: json['userId'] as String,
            ),
    );
  }
}

class AuthSessionModel {
  const AuthSessionModel(this.json);
  final Map<String, dynamic> json;

  AuthSession toDomain() => AuthSession(
        accessToken: json['accessToken'] as String,
        tokenType: json['tokenType'] as String? ?? 'Bearer',
        expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 0,
        role: _role(json['role'] as String),
        userId: json['userId'] as String,
      );
}

class TrainerProfileModel {
  const TrainerProfileModel(this.json);
  final Map<String, dynamic> json;

  TrainerProfile toDomain() => TrainerProfile(
        id: json['id'] as String,
        email: json['email'] as String,
        displayName: json['displayName'] as String,
        status: json['status'] as String,
        specialization: json['specialization'] as String?,
      );
}
