enum BaselineAngle { front, side, back }

extension BaselineAngleApi on BaselineAngle {
  String get apiValue => name.toUpperCase();
}

class StartingBaselinePhoto {
  const StartingBaselinePhoto({
    required this.id,
    required this.angle,
    required this.uploadConfirmed,
    this.contentType,
    this.sizeBytes,
    this.uploadConfirmedAt,
  });

  final String id;
  final BaselineAngle angle;
  final bool uploadConfirmed;
  final String? contentType;
  final int? sizeBytes;
  final DateTime? uploadConfirmedAt;
}

class BaselineUploadIntent {
  const BaselineUploadIntent({
    required this.photoId,
    required this.angle,
    required this.url,
    required this.requiredHeaders,
    this.expiresAt,
  });

  final String photoId;
  final BaselineAngle angle;
  final Uri url;
  final Map<String, String> requiredHeaders;
  final DateTime? expiresAt;
}

class StartingBaseline {
  const StartingBaseline({
    required this.requirement,
    required this.status,
    required this.photos,
    this.baselineId,
    this.startingWeightKg,
    this.completedAt,
  });

  final String requirement;
  final String status;
  final String? baselineId;
  final double? startingWeightKg;
  final DateTime? completedAt;
  final List<StartingBaselinePhoto> photos;

  bool get completed => status == 'COMPLETED';
  bool get inProgress => status == 'IN_PROGRESS';
  bool get allRequiredPhotosConfirmed => BaselineAngle.values.every(
        (angle) => photos.any((photo) => photo.angle == angle && photo.uploadConfirmed),
      );
}
