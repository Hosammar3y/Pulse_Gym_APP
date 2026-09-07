import '../entities/today_snapshot.dart';
abstract interface class TodayRepository { Future<TodaySnapshot> load(); }
