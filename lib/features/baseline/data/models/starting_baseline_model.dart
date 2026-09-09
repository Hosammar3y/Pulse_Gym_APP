import '../../domain/entities/starting_baseline.dart';

class StartingBaselineModel {
  const StartingBaselineModel(this.json);
  final Map<String, dynamic> json;

  StartingBaseline toEntity() => StartingBaseline(
        requirement: json['requirement'] as String? ?? 'OPTIONAL',
        status: json['status'] as String? ?? 'NOT_STARTED',
        baselineId: json['baselineId'] as String?,
        startingWeightKg: (json['startingWeightKg'] as num?)?.toDouble(),
        completedAt: json['completedAt'] is String ? DateTime.tryParse(json['completedAt'] as String) : null,
        photos: ((json['photos'] as List?) ?? const <dynamic>[]).map((entry) {
          final map = Map<String, dynamic>.from(entry as Map);
          return StartingBaselinePhoto(
            id: map['id'] as String,
            angle: _angle(map['angle']),
            uploadConfirmed: map['uploadConfirmed'] as bool? ?? false,
            contentType: map['contentType'] as String?,
            sizeBytes: (map['sizeBytes'] as num?)?.toInt(),
            uploadConfirmedAt: map['uploadConfirmedAt'] is String ? DateTime.tryParse(map['uploadConfirmedAt'] as String) : null,
          );
        }).toList(growable: false),
      );
}

BaselineUploadIntent parseBaselineUploadIntent(Map<String, dynamic> json) {
  final intent = Map<String, dynamic>.from(json['intent'] as Map);
  final rawHeaders = intent['requiredHeaders'];
  final headers = <String, String>{};
  if (rawHeaders is Map) {
    for (final entry in rawHeaders.entries) {
      headers[entry.key.toString()] = entry.value.toString();
    }
  }
  return BaselineUploadIntent(
    photoId: json['photoId'] as String,
    angle: _angle(json['angle']),
    url: Uri.parse(intent['url'] as String),
    expiresAt: intent['expiresAt'] is String ? DateTime.tryParse(intent['expiresAt'] as String) : null,
    requiredHeaders: Map.unmodifiable(headers),
  );
}

BaselineAngle _angle(Object? value) => switch (value?.toString().toUpperCase()) {
      'SIDE' => BaselineAngle.side,
      'BACK' => BaselineAngle.back,
      _ => BaselineAngle.front,
    };
