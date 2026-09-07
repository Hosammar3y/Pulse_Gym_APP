import '../entities/app_notification.dart';

abstract interface class NotificationsRepository {
  Future<List<AppNotification>> list();
  Future<AppNotification> markRead(String id);
  Stream<AppNotification> stream();
}
