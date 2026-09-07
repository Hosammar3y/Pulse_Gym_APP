import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coach_mobile/features/today/data/models/today_snapshot_model.dart';

void main() {
  test('today snapshot counts client states and queues', () {
    final snapshot = TodaySnapshotModel(
      profile: <String, dynamic>{'displayName': 'Coach Omar'},
      clients: <dynamic>[
        <String, dynamic>{'id': '1', 'firstName': 'A', 'lastName': 'One', 'goal': 'Fat loss', 'status': 'ACTIVE'},
        <String, dynamic>{'id': '2', 'firstName': 'B', 'lastName': 'Two', 'goal': 'Muscle', 'status': 'PAUSED'},
        <String, dynamic>{'id': '3', 'firstName': 'C', 'lastName': 'Three', 'goal': 'Fitness', 'status': 'EXPIRED'},
      ],
      reviews: <dynamic>[<String, dynamic>{'id': 'r'}],
      renewals: <dynamic>[<String, dynamic>{'id': 'n1'}, <String, dynamic>{'id': 'n2'}],
    ).toDomain();

    expect(snapshot.trainerName, 'Coach Omar');
    expect(snapshot.activeClients, 1);
    expect(snapshot.pausedClients, 1);
    expect(snapshot.expiredClients, 1);
    expect(snapshot.reviewsWaiting, 1);
    expect(snapshot.renewalsWaiting, 2);
    expect(snapshot.recentClients, hasLength(3));
  });
}
