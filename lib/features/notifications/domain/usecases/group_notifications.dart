import '../entities/app_notification.dart';

class NotificationGroup {
  const NotificationGroup({required this.groupKey, required this.latest, required this.members, required this.unreadCount});

  final String groupKey;
  final AppNotification latest;
  final List<AppNotification> members;
  final int unreadCount;
}

class GroupNotifications {
  const GroupNotifications();

  List<NotificationGroup> call(List<AppNotification> items) {
    final sorted = [...items]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final groups = <String, List<AppNotification>>{};
    final seen = <String>{};

    for (final item in sorted) {
      final identity = '${item.recipientUserId}:${item.id}';
      if (!seen.add(identity)) continue;
      groups.putIfAbsent(_groupKey(item), () => <AppNotification>[]).add(item);
    }

    return groups.entries
        .map(
          (entry) => NotificationGroup(
            groupKey: entry.key,
            latest: entry.value.first,
            members: List.unmodifiable(entry.value),
            unreadCount: entry.value.where((item) => item.isUnread).length,
          ),
        )
        .toList(growable: false);
  }

  String _groupKey(AppNotification item) {
    final isReply = item.type == 'TICKET_TRAINER_REPLIED' || item.type == 'TICKET_TRAINEE_REPLIED';
    if (isReply && item.sourceEntityType == 'TICKET_MESSAGE' && item.deepLink != null) {
      final match = RegExp(r'^/(?:trainer/tickets|me/ask-coach)/([\da-f-]{36})$', caseSensitive: false).firstMatch(item.deepLink!);
      final ticketId = match?.group(1);
      if (ticketId != null) return '${item.recipientUserId}:ticket-replies:${ticketId.toLowerCase()}';
    }
    return '${item.recipientUserId}:notification:${item.id}';
  }
}
