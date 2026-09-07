import '../entities/auth_session.dart';
import '../repositories/auth_repository.dart';

class Login {
  const Login(this._repository);
  final AuthRepository _repository;
  Future<LoginResult> call(String email, String password) => _repository.login(email, password);
}
