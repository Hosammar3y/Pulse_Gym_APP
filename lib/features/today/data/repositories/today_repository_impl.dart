import '../../domain/entities/today_snapshot.dart';
import '../../domain/repositories/today_repository.dart';
import '../datasources/today_remote_data_source.dart';
import '../models/today_snapshot_model.dart';

class TodayRepositoryImpl implements TodayRepository {
  const TodayRepositoryImpl(this._remote);
  final TodayRemoteDataSource _remote;

  @override
  Future<TodaySnapshot> load() async {
    final parts = await _remote.load();
    return TodaySnapshotModel(
      profile: parts[0] as Map<String, dynamic>,
      clients: parts[1] as List<dynamic>,
      reviews: parts[2] as List<dynamic>,
      renewals: parts[3] as List<dynamic>,
    ).toDomain();
  }
}
