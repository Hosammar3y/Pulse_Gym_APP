import '../entities/client.dart';
import '../repositories/clients_repository.dart';
class GetClient { const GetClient(this._repository); final ClientsRepository _repository; Future<Client> call(String id)=>_repository.get(id); }
