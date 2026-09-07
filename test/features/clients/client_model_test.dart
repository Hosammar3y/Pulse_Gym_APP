import 'package:flutter_test/flutter_test.dart';
import 'package:pulse_coach_mobile/features/clients/data/models/client_model.dart';
import 'package:pulse_coach_mobile/features/clients/domain/entities/client.dart';

void main() {
  test('client model preserves production statuses and baseline fields', () {
    final client = const ClientModel(<String, dynamic>{
      'id': 't1', 'email': 'a@example.com', 'firstName': 'Ahmed', 'lastName': 'Hassan', 'goal': 'Fat loss',
      'trainingLevel': 'INTERMEDIATE', 'heightCm': 180, 'status': 'PAUSED',
      'subscriptionStartDate': '2026-09-01', 'subscriptionEndDate': '2026-10-01', 'subscriptionStatus': 'ACTIVE',
      'baselineRequirement': 'REQUIRED', 'baselineStatus': 'COMPLETED',
    }).toEntity();
    expect(client.status, ClientStatus.paused);
    expect(client.trainingLevel, TrainingLevel.intermediate);
    expect(client.baselineRequirement, BaselineRequirement.required);
    expect(client.baselineStatus, BaselineStatus.completed);
  });

  test('create payload uses canonical enum/date representations', () {
    final payload = createClientJson(CreateClientInput(
      firstName: 'Ahmed', lastName: 'Hassan', email: 'a@example.com', goal: 'Fat loss',
      trainingLevel: TrainingLevel.advanced, subscriptionStartDate: DateTime(2026, 9, 7), baselineRequirement: BaselineRequirement.required,
    ));
    expect(payload['trainingLevel'], 'ADVANCED');
    expect(payload['subscriptionStartDate'], '2026-09-07');
    expect(payload['baselineRequirement'], 'REQUIRED');
  });
}
