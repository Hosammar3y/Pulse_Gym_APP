abstract final class ApiEndpoints {
  static const notifications = '/notifications';
  static const notificationStream = '/notifications/stream';

  static String markNotificationRead(String id) => '/notifications/$id/read';
  static const markAllNotificationsRead = '/notifications/read-all';
}
