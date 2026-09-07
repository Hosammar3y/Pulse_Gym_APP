import '../entities/client.dart';
import '../repositories/clients_repository.dart';
class CreateClient { const CreateClient(this._repository); final ClientsRepository _repository; Future<Client> call(CreateClientInput input)=>_repository.create(input); }
