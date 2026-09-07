import 'dart:convert';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../models/app_notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._remote, this._realtime);

  final NotificationsRemoteDataSource _remote;
  final RealtimeClient _realtime;

  @override
  Future<List<AppNotification>> list() async => (await _remote.list()).map((model) => model.toEntity()).toList(growable: false);

  @override
  Future<AppNotification> markRead(String id) async => (await _remote.markRead(id)).toEntity();

  @override
  Stream<AppNotification> stream() async* {
    await for (final event in _realtime.connect(ApiEndpoints.notificationStream)) {
      if (event.event != 'notification') continue;
      final json = jsonDecode(event.data) as Map<String, dynamic>;
      yield AppNotificationModel.fromJson(json).toEntity();
    }
  }
}
