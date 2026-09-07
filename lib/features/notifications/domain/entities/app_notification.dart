class AppNotification {
  const AppNotification({
    required this.id,
    required this.recipientUserId,
    required this.type,
    required this.title,
    required this.body,
    required this.sourceEntityType,
    required this.sourceEntityId,
    required this.createdAt,
    this.deepLink,
    this.readAt,
  });

  final String id;
  final String recipientUserId;
  final String type;
  final String title;
  final String body;
  final String? deepLink;
  final String sourceEntityType;
  final String sourceEntityId;
  final DateTime? readAt;
  final DateTime createdAt;

  bool get isUnread => readAt == null;
}
