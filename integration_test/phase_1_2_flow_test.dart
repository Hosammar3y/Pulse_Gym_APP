import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pulse_coach_mobile/features/clients/domain/entities/client.dart';
import 'package:pulse_coach_mobile/features/clients/domain/repositories/clients_repository.dart';
import 'package:pulse_coach_mobile/features/clients/presentation/pages/clients_page.dart';
import 'package:pulse_coach_mobile/features/clients/presentation/providers/clients_providers.dart';
import 'package:pulse_coach_mobile/features/today/domain/entities/today_snapshot.dart';
import 'package:pulse_coach_mobile/features/today/domain/repositories/today_repository.dart';
import 'package:pulse_coach_mobile/features/today/presentation/pages/today_page.dart';
import 'package:pulse_coach_mobile/features/today/presentation/providers/today_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('phase 1 Today renders authoritative workbench snapshot', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          todayRepositoryProvider.overrideWithValue(_FakeTodayRepository()),
        ],
        child: const MaterialApp(home: TodayPage()),
      ),
    );
    await tester.pumpAndSettle();

    // Initial viewport assertions.
    expect(find.text('Welcome, Coach Omar'), findsOneWidget);
    expect(find.text('Active Clients'), findsOneWidget);

    // TodayPage uses a lazy ListView, so lower sections may not be built until
    // they are scrolled into view on the Linux integration-test viewport.
    await tester.scrollUntilVisible(
      find.text('Recent Clients'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Recent Clients'), findsOneWidget);
    expect(find.text('Ahmed Hassan'), findsOneWidget);
  });

  testWidgets('phase 2 client directory renders server-owned client data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          clientsRepositoryProvider.overrideWithValue(_FakeClientsRepository()),
        ],
        child: const MaterialApp(home: ClientsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ahmed Hassan'), findsOneWidget);
    expect(find.textContaining('Fat loss'), findsOneWidget);
  });
}

class _FakeTodayRepository implements TodayRepository {
  @override
  Future<TodaySnapshot> load() async => const TodaySnapshot(
        trainerName: 'Coach Omar',
        activeClients: 1,
        pausedClients: 0,
        expiredClients: 0,
        reviewsWaiting: 1,
        renewalsWaiting: 0,
        recentClients: <TodayClient>[
          TodayClient(
            id: 't1',
            name: 'Ahmed Hassan',
            goal: 'Fat loss',
            status: 'ACTIVE',
          ),
        ],
      );
}

class _FakeClientsRepository implements ClientsRepository {
  final Client client = Client(
    id: 't1',
    email: 'a@example.com',
    firstName: 'Ahmed',
    lastName: 'Hassan',
    goal: 'Fat loss',
    status: ClientStatus.active,
    subscriptionStartDate: DateTime(2026, 9, 1),
    subscriptionEndDate: DateTime(2026, 10, 1),
    subscriptionStatus: 'ACTIVE',
  );

  @override
  Future<List<Client>> list({String query = '', String status = 'ALL'}) async =>
      <Client>[client];

  @override
  Future<Client> get(String id) async => client;

  @override
  Future<Client> create(CreateClientInput input) async => client;

  @override
  Future<Client> pause(String id, {DateTime? pauseUntil}) async => client;

  @override
  Future<Client> resume(String id) async => client;
}
