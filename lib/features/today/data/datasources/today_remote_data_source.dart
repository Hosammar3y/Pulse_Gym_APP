import '../../../../core/network/api_client.dart';

class TodayRemoteDataSource {
  const TodayRemoteDataSource(this._api);
  final ApiClient _api;

  Future<List<Object?>> load() async => Future.wait<Object?>(<Future<Object?>>[
        _api.get<Map<String, dynamic>>('/trainer/profile'),
        _api.get<List<dynamic>>('/trainer/trainees'),
        _api.get<List<dynamic>>('/trainer/checkins'),
        _api.get<List<dynamic>>('/trainer/renewal-requests', queryParameters: const <String, dynamic>{'status': 'PENDING'}),
      ]);
}
