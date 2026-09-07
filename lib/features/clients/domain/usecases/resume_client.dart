import '../entities/client.dart'; import '../repositories/clients_repository.dart';
class ResumeClient { const ResumeClient(this._repository); final ClientsRepository _repository; Future<Client> call(String id)=>_repository.resume(id); }
