import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/datasources/baseline_remote_data_source.dart';
import '../../data/repositories/baseline_repository_impl.dart';
import '../../domain/entities/starting_baseline.dart';
import '../../domain/repositories/baseline_repository.dart';
import '../../domain/usecases/get_starting_baseline.dart';

final baselineRepositoryProvider = Provider<BaselineRepository>(
  (ref) => BaselineRepositoryImpl(BaselineRemoteDataSource(ref.watch(apiClientProvider))),
);

final startingBaselineProvider = FutureProvider.autoDispose.family<StartingBaseline, String>(
  (ref, id) => GetStartingBaseline(ref.watch(baselineRepositoryProvider))(id),
);

class BaselineMutationController extends AutoDisposeAsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> upload(
    String traineeId,
    BaselineAngle angle,
    Uint8List bytes,
    String contentType,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(baselineRepositoryProvider).uploadPhoto(traineeId, angle, bytes, contentType);
      ref.invalidate(startingBaselineProvider(traineeId));
    });
    return !state.hasError;
  }

  Future<bool> remove(String traineeId, String photoId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(baselineRepositoryProvider).removePhoto(traineeId, photoId);
      ref.invalidate(startingBaselineProvider(traineeId));
    });
    return !state.hasError;
  }

  Future<bool> complete(String traineeId, double startingWeightKg) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(baselineRepositoryProvider).complete(traineeId, startingWeightKg);
      ref.invalidate(startingBaselineProvider(traineeId));
    });
    return !state.hasError;
  }
}

final baselineMutationControllerProvider = AutoDisposeAsyncNotifierProvider<BaselineMutationController, void>(
  BaselineMutationController.new,
);
