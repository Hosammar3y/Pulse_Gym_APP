import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/clients_remote_data_source.dart';
import '../../data/repositories/clients_repository_impl.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/clients_repository.dart';
import '../../domain/usecases/get_client.dart';
import '../../domain/usecases/get_clients.dart';

final clientsRepositoryProvider = Provider<ClientsRepository>((ref) =>
    ClientsRepositoryImpl(ClientsRemoteDataSource(ref.watch(apiClientProvider))));

final clientsQueryProvider = StateProvider<String>((ref) => '');
final clientsStatusProvider = StateProvider<String>((ref) => 'ALL');

final clientsProvider = FutureProvider.autoDispose<List<Client>>((ref) async {
  final query = ref.watch(clientsQueryProvider);
  final status = ref.watch(clientsStatusProvider);
  return GetClients(ref.watch(clientsRepositoryProvider))(query: query, status: status);
});

final clientProvider = FutureProvider.autoDispose.family<Client, String>((ref, id) =>
    GetClient(ref.watch(clientsRepositoryProvider))(id));
