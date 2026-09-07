import '../entities/client.dart';
import '../repositories/clients_repository.dart';

class GetClients {
  const GetClients(this._repository);
  final ClientsRepository _repository;
  Future<List<Client>> call({String query = '', String status = 'ALL'}) => _repository.list(query: query, status: status);
}
