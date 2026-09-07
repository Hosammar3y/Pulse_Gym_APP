import '../../domain/entities/app_notification.dart';

class AppNotificationModel {
  const AppNotificationModel({
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

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) => AppNotificationModel(
        id: json['id'] as String,
        recipientUserId: json['recipientUserId'] as String,
        type: json['type'] as String,
        title: json['title'] as String,
        body: json['body'] as String,
        deepLink: json['deepLink'] as String?,
        sourceEntityType: json['sourceEntityType'] as String,
        sourceEntityId: json['sourceEntityId'] as String,
        readAt: json['readAt'] == null ? null : DateTime.parse(json['readAt'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  AppNotification toEntity() => AppNotification(
        id: id,
        recipientUserId: recipientUserId,
        type: type,
        title: title,
        body: body,
        deepLink: deepLink,
        sourceEntityType: sourceEntityType,
        sourceEntityId: sourceEntityId,
        readAt: readAt,
        createdAt: createdAt,
      );
}
