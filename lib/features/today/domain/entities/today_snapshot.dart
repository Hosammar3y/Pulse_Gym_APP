class TodayClient {
  const TodayClient({required this.id, required this.name, required this.goal, required this.status});
  final String id;
  final String name;
  final String goal;
  final String status;
}

class TodaySnapshot {
  const TodaySnapshot({
    required this.trainerName,
    required this.activeClients,
    required this.pausedClients,
    required this.expiredClients,
    required this.reviewsWaiting,
    required this.renewalsWaiting,
    required this.recentClients,
  });

  final String trainerName;
  final int activeClients;
  final int pausedClients;
  final int expiredClients;
  final int reviewsWaiting;
  final int renewalsWaiting;
  final List<TodayClient> recentClients;
}
