import '../../../../core/network/api_client.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._api);
  final ApiClient _api;

  Future<Map<String, dynamic>> login(String email, String password) =>
      _api.post<Map<String, dynamic>>('/auth/login', data: <String, dynamic>{'email': email, 'password': password});

  Future<Map<String, dynamic>> completeTemporaryPassword(String token, String password) =>
      _api.post<Map<String, dynamic>>('/auth/complete-temporary-password', data: <String, dynamic>{
        'token': token,
        'password': password,
      });

  Future<Map<String, dynamic>> refresh() => _api.post<Map<String, dynamic>>('/auth/refresh');

  Future<void> logout() => _api.post<void>('/auth/logout');

  Future<Map<String, dynamic>> trainerProfile() => _api.get<Map<String, dynamic>>('/trainer/profile');
}
