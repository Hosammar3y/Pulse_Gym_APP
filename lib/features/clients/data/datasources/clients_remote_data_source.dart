import '../../../../core/network/api_client.dart';
import '../models/client_model.dart';
import '../../domain/entities/client.dart';

class ClientsRemoteDataSource {
  const ClientsRemoteDataSource(this._api);
  final ApiClient _api;

  Future<List<ClientModel>> list({String query = '', String status = 'ALL'}) async {
    final data = await _api.get<List<dynamic>>('/trainer/trainees', queryParameters: <String, dynamic>{
      if (query.isNotEmpty) 'q': query,
      if (status != 'ALL') 'status': status,
    });
    return data.map((e) => ClientModel(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<ClientModel> get(String id) async => ClientModel(
        Map<String, dynamic>.from(await _api.get<Map<String, dynamic>>('/trainer/trainees/$id')),
      );

  Future<ClientModel> create(CreateClientInput input) async => ClientModel(
        Map<String, dynamic>.from(await _api.post<Map<String, dynamic>>('/trainer/trainees', data: createClientJson(input))),
      );

  Future<ClientModel> pause(String id, DateTime? pauseUntil) async => ClientModel(
        Map<String, dynamic>.from(await _api.post<Map<String, dynamic>>('/trainer/trainees/$id/pause', data: <String, dynamic>{'pauseUntil': pauseUntil?.toIso8601String()})),
      );

  Future<ClientModel> resume(String id) async => ClientModel(
        Map<String, dynamic>.from(await _api.post<Map<String, dynamic>>('/trainer/trainees/$id/resume')),
      );
}
