import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coach_mobile/features/notifications/domain/entities/app_notification.dart';
import 'package:pulse_coach_mobile/features/notifications/domain/usecases/group_notifications.dart';

void main() {
  AppNotification reply(String id, {DateTime? readAt, String ticket = '11111111-1111-4111-8111-111111111111'}) => AppNotification(
        id: id,
        recipientUserId: 'trainer',
        type: 'TICKET_TRAINEE_REPLIED',
        title: 'Trainee replied',
        body: 'Ahmed replied',
        deepLink: '/trainer/tickets/$ticket',
        sourceEntityType: 'TICKET_MESSAGE',
        sourceEntityId: id,
        readAt: readAt,
        createdAt: DateTime.utc(2026, 9, 7, 10, int.parse(id)),
      );

  test('ticket replies group and increment unread count', () {
    final groups = const GroupNotifications()(<AppNotification>[reply('1'), reply('2'), reply('3')]);
    expect(groups, hasLength(1));
    expect(groups.single.unreadCount, 3);
    expect(groups.single.members, hasLength(3));
  });

  test('read members and different tickets are handled independently', () {
    final groups = const GroupNotifications()(<AppNotification>[
      reply('1', readAt: DateTime.utc(2026)),
      reply('2'),
      reply('3', ticket: '22222222-2222-4222-8222-222222222222'),
    ]);
    expect(groups, hasLength(2));
    expect(groups.map((group) => group.unreadCount).reduce((a, b) => a + b), 2);
  });
}
