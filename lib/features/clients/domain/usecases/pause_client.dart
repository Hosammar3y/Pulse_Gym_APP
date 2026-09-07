import '../entities/client.dart'; import '../repositories/clients_repository.dart';
class PauseClient { const PauseClient(this._repository); final ClientsRepository _repository; Future<Client> call(String id,{DateTime? pauseUntil})=>_repository.pause(id,pauseUntil:pauseUntil); }
