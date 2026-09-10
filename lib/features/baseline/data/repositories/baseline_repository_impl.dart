import 'dart:typed_data';

import '../../domain/entities/starting_baseline.dart';
import '../../domain/repositories/baseline_repository.dart';
import '../datasources/baseline_remote_data_source.dart';

class BaselineRepositoryImpl implements BaselineRepository {
  const BaselineRepositoryImpl(this._remote);
  final BaselineRemoteDataSource _remote;

  @override
  Future<StartingBaseline> getForTrainer(String traineeId) async => (await _remote.trainerView(traineeId)).toEntity();

  @override
  Future<Uri> getPhotoReadUri(String traineeId, String photoId) async {
    final data = await _remote.photoReadAccess(traineeId, photoId);
    return Uri.parse(data['url'] as String);
  }

  @override
  Future<StartingBaseline> uploadPhoto(
    String traineeId,
    BaselineAngle angle,
    Uint8List bytes,
    String contentType,
  ) async {
    final intent = await _remote.requestUploadIntent(traineeId, angle, contentType);
    await _remote.uploadBytes(intent, bytes, contentType);
    await _remote.confirm(traineeId, intent.photoId);
    return (await _remote.trainerView(traineeId)).toEntity();
  }

  @override
  Future<StartingBaseline> removePhoto(String traineeId, String photoId) async {
    await _remote.remove(traineeId, photoId);
    return (await _remote.trainerView(traineeId)).toEntity();
  }

  @override
  Future<StartingBaseline> complete(String traineeId, double startingWeightKg) async =>
      (await _remote.complete(traineeId, startingWeightKg)).toEntity();
}
