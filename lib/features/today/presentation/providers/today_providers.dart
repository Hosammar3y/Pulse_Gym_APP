import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/today_remote_data_source.dart';
import '../../data/repositories/today_repository_impl.dart';
import '../../domain/entities/today_snapshot.dart';
import '../../domain/repositories/today_repository.dart';

final todayRepositoryProvider = Provider<TodayRepository>((ref) => TodayRepositoryImpl(TodayRemoteDataSource(ref.watch(apiClientProvider))));
final todaySnapshotProvider = FutureProvider.autoDispose<TodaySnapshot>((ref) => ref.watch(todayRepositoryProvider).load());
