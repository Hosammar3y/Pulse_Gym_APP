import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coach_mobile/features/baseline/data/models/starting_baseline_model.dart';
import 'package:pulse_coach_mobile/features/baseline/domain/entities/starting_baseline.dart';

void main() {
  test('baseline maps all required angles', () {
    final baseline = StartingBaselineModel(<String, dynamic>{
      'requirement': 'REQUIRED',
      'status': 'COMPLETED',
      'baselineId': 'b1',
      'startingWeightKg': 91.5,
      'completedAt': '2026-09-01T10:00:00Z',
      'photos': <dynamic>[
        <String, dynamic>{'id': 'f', 'angle': 'FRONT', 'uploadConfirmed': true},
        <String, dynamic>{'id': 's', 'angle': 'SIDE', 'uploadConfirmed': true},
        <String, dynamic>{'id': 'b', 'angle': 'BACK', 'uploadConfirmed': true},
      ],
    }).toEntity();

    expect(baseline.photos.map((photo) => photo.angle).toSet(), <BaselineAngle>{BaselineAngle.front, BaselineAngle.side, BaselineAngle.back});
    expect(baseline.startingWeightKg, 91.5);
  });
}
