import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/app_notification_model.dart';

class NotificationsRemoteDataSource {
  const NotificationsRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<AppNotificationModel>> list() async {
    final data = await _client.get<List<dynamic>>(ApiEndpoints.notifications);
    return data
        .cast<Map<String, dynamic>>()
        .map(AppNotificationModel.fromJson)
        .toList(growable: false);
  }

  Future<AppNotificationModel> markRead(String id) async {
    final data = await _client.post<Map<String, dynamic>>(ApiEndpoints.markNotificationRead(id));
    return AppNotificationModel.fromJson(data);
  }
}
