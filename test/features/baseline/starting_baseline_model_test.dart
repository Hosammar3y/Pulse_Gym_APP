import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coach_mobile/features/baseline/data/models/starting_baseline_model.dart';
import 'package:pulse_coach_mobile/features/baseline/domain/entities/starting_baseline.dart';

void main() {
  test('baseline maps all required angles and completion readiness', () {
    final baseline = const StartingBaselineModel(<String, dynamic>{
      'requirement': 'REQUIRED',
      'status': 'COMPLETED',
      'baselineId': 'b1',
      'startingWeightKg': 91.5,
      'completedAt': '2026-09-01T10:00:00Z',
      'photos': <dynamic>[
        <String, dynamic>{'id': 'f', 'angle': 'FRONT', 'uploadConfirmed': true, 'contentType': 'image/jpeg', 'sizeBytes': 100},
        <String, dynamic>{'id': 's', 'angle': 'SIDE', 'uploadConfirmed': true},
        <String, dynamic>{'id': 'b', 'angle': 'BACK', 'uploadConfirmed': true},
      ],
    }).toEntity();
    expect(baseline.photos.map((photo) => photo.angle).toSet(), <BaselineAngle>{BaselineAngle.front, BaselineAngle.side, BaselineAngle.back});
    expect(baseline.startingWeightKg, 91.5);
    expect(baseline.allRequiredPhotosConfirmed, isTrue);
    expect(baseline.photos.first.contentType, 'image/jpeg');
  });

  test('upload intent preserves every dynamic required header', () {
    final intent = parseBaselineUploadIntent(<String, dynamic>{
      'photoId': '11111111-2222-3333-4444-555555555555',
      'angle': 'SIDE',
      'intent': <String, dynamic>{
        'url': 'https://storage.test/signed-upload',
        'expiresAt': '2026-09-10T00:20:00Z',
        'requiredHeaders': <String, dynamic>{
          'x-ms-blob-type': 'BlockBlob',
          'x-provider-signature': 42,
        },
      },
    });

    expect(intent.photoId, '11111111-2222-3333-4444-555555555555');
    expect(intent.angle, BaselineAngle.side);
    expect(intent.url.toString(), 'https://storage.test/signed-upload');
    expect(intent.requiredHeaders, <String, String>{'x-ms-blob-type': 'BlockBlob', 'x-provider-signature': '42'});
  });
}
