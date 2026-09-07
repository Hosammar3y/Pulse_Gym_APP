import '../../domain/entities/client.dart';
import '../../domain/repositories/clients_repository.dart';
import '../datasources/clients_remote_data_source.dart';

class ClientsRepositoryImpl implements ClientsRepository {
  const ClientsRepositoryImpl(this._remote);
  final ClientsRemoteDataSource _remote;

  @override
  Future<List<Client>> list({String query = '', String status = 'ALL'}) async =>
      (await _remote.list(query: query, status: status)).map((e) => e.toEntity()).toList();

  @override
  Future<Client> get(String id) async => (await _remote.get(id)).toEntity();

  @override
  Future<Client> create(CreateClientInput input) async => (await _remote.create(input)).toEntity();

  @override
  Future<Client> pause(String id, {DateTime? pauseUntil}) async => (await _remote.pause(id, pauseUntil)).toEntity();

  @override
  Future<Client> resume(String id) async => (await _remote.resume(id)).toEntity();
}
