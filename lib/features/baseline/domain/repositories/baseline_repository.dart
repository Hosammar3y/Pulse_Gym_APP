import 'dart:typed_data';

import '../entities/starting_baseline.dart';

abstract interface class BaselineRepository {
  Future<StartingBaseline> getForTrainer(String traineeId);
  Future<Uri> getPhotoReadUri(String traineeId, String photoId);
  Future<StartingBaseline> uploadPhoto(
    String traineeId,
    BaselineAngle angle,
    Uint8List bytes,
    String contentType,
  );
  Future<StartingBaseline> removePhoto(String traineeId, String photoId);
  Future<StartingBaseline> complete(String traineeId, double startingWeightKg);
}
