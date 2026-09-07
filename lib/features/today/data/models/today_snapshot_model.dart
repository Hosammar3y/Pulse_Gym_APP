import '../../domain/entities/today_snapshot.dart';

class TodaySnapshotModel {
  const TodaySnapshotModel({required this.profile, required this.clients, required this.reviews, required this.renewals});
  final Map<String, dynamic> profile;
  final List<dynamic> clients;
  final List<dynamic> reviews;
  final List<dynamic> renewals;

  TodaySnapshot toDomain() {
    final rows = clients.cast<Map<String, dynamic>>();
    int count(String status) => rows.where((client) => client['status'] == status).length;
    return TodaySnapshot(
      trainerName: profile['displayName'] as String? ?? 'Coach',
      activeClients: count('ACTIVE'),
      pausedClients: count('PAUSED'),
      expiredClients: count('EXPIRED'),
      reviewsWaiting: reviews.length,
      renewalsWaiting: renewals.length,
      recentClients: rows.take(6).map((client) => TodayClient(
        id: client['id'] as String,
        name: '${client['firstName'] ?? ''} ${client['lastName'] ?? ''}'.trim(),
        goal: client['goal'] as String? ?? '',
        status: client['status'] as String? ?? 'UNKNOWN',
      )).toList(growable: false),
    );
  }
}
