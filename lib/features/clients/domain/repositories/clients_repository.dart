import '../entities/client.dart';

abstract interface class ClientsRepository {
  Future<List<Client>> list({String query = '', String status = 'ALL'});
  Future<Client> get(String id);
  Future<Client> create(CreateClientInput input);
  Future<Client> pause(String id, {DateTime? pauseUntil});
  Future<Client> resume(String id);
}
