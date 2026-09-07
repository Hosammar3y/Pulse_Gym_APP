enum AuthRole { admin, trainer, trainee }

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.expiresInSeconds,
    required this.role,
    required this.userId,
  });

  final String accessToken;
  final String tokenType;
  final int expiresInSeconds;
  final AuthRole role;
  final String userId;
}

class LoginResult {
  const LoginResult({
    this.session,
    required this.role,
    required this.userId,
    required this.passwordChangeRequired,
    this.passwordChangeToken,
  });

  final AuthSession? session;
  final AuthRole role;
  final String userId;
  final bool passwordChangeRequired;
  final String? passwordChangeToken;
}

class TrainerProfile {
  const TrainerProfile({
    required this.id,
    required this.email,
    required this.displayName,
    required this.status,
    this.specialization,
  });

  final String id;
  final String email;
  final String displayName;
  final String status;
  final String? specialization;
}
