import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coach_mobile/features/auth/data/models/auth_models.dart';
import 'package:pulse_coach_mobile/features/auth/domain/entities/auth_session.dart';

void main() {
  test('login result maps trainer session', () {
    final result = LoginResultModel(<String, dynamic>{
      'accessToken': 'token',
      'tokenType': 'Bearer',
      'expiresInSeconds': 3600,
      'role': 'TRAINER',
      'userId': 'u-1',
      'passwordChangeRequired': false,
    }).toDomain();

    expect(result.role, AuthRole.trainer);
    expect(result.session?.accessToken, 'token');
    expect(result.passwordChangeRequired, isFalse);
  });

  test('temporary password result may have no access token', () {
    final result = LoginResultModel(<String, dynamic>{
      'role': 'TRAINER',
      'userId': 'u-1',
      'expiresInSeconds': 0,
      'passwordChangeRequired': true,
      'passwordChangeToken': 'change-me',
    }).toDomain();
    expect(result.session, isNull);
    expect(result.passwordChangeToken, 'change-me');
  });
}
