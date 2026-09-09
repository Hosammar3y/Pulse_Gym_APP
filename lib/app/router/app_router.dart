import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/change_temporary_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/baseline/presentation/pages/baseline_page.dart';
import '../../features/clients/presentation/pages/add_client_page.dart';
import '../../features/clients/presentation/pages/client_details_page.dart';
import '../../features/clients/presentation/pages/clients_page.dart';
import '../../features/inbox/presentation/pages/inbox_page.dart';
import '../../features/more/presentation/pages/more_page.dart';
import '../../features/notifications/presentation/pages/notification_center_page.dart';
import '../../features/programs/presentation/pages/programs_page.dart';
import '../../features/today/presentation/pages/today_page.dart';
import '../../shared/widgets/app_shell.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authControllerProvider);
  final challenge = ref.watch(temporaryPasswordChallengeProvider);
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      if (auth.isLoading) return null;
      final signedIn = auth.valueOrNull != null;
      final atLogin = state.matchedLocation == '/login';
      final atTemporaryChange = state.matchedLocation == '/change-temporary-password';

      if (challenge != null) {
        return atTemporaryChange ? null : '/change-temporary-password';
      }
      if (atTemporaryChange) return '/login';
      if (!signedIn && !atLogin) return '/login';
      if (signedIn && atLogin) return '/today';
      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: '/login', name: RouteNames.login, builder: (context, state) => const LoginPage()),
      GoRoute(path: '/change-temporary-password', builder: (context, state) => const ChangeTemporaryPasswordPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(routes: <RouteBase>[GoRoute(path: '/today', name: RouteNames.today, builder: (context, state) => const TodayPage())]),
          StatefulShellBranch(routes: <RouteBase>[GoRoute(path: '/clients', name: RouteNames.clients, builder: (context, state) => const ClientsPage(), routes: <RouteBase>[
            GoRoute(path: 'new', builder: (context, state) => const AddClientPage()),
            GoRoute(path: ':clientId', builder: (context, state) => ClientDetailsPage(clientId: state.pathParameters['clientId']!), routes: <RouteBase>[
              GoRoute(path: 'baseline', builder: (context, state) => BaselinePage(clientId: state.pathParameters['clientId']!)),
              GoRoute(path: 'program/workout', builder: (context, state) => const _DeferredFeature(title: 'Workout', phase: 3)),
              GoRoute(path: 'program/diet', builder: (context, state) => const _DeferredFeature(title: 'Diet', phase: 4)),
              GoRoute(path: 'program/cardio', builder: (context, state) => const _DeferredFeature(title: 'Cardio', phase: 5)),
              GoRoute(path: 'progress', builder: (context, state) => const _DeferredFeature(title: 'Progress', phase: 6)),
              GoRoute(path: 'checkins', builder: (context, state) => const _DeferredFeature(title: 'Check-ins', phase: 7)),
            ]),
          ])]),
          StatefulShellBranch(routes: <RouteBase>[GoRoute(path: '/programs', name: RouteNames.programs, builder: (context, state) => const ProgramsPage())]),
          StatefulShellBranch(routes: <RouteBase>[GoRoute(path: '/inbox', name: RouteNames.inbox, builder: (context, state) => const InboxPage())]),
          StatefulShellBranch(routes: <RouteBase>[GoRoute(path: '/more', name: RouteNames.more, builder: (context, state) => const MorePage(), routes: <RouteBase>[
            GoRoute(path: 'notifications', name: RouteNames.notifications, builder: (context, state) => const NotificationCenterPage()),
            GoRoute(path: 'checkin-reviews', builder: (context, state) => const _DeferredFeature(title: 'Check-in Reviews', phase: 7)),
            GoRoute(path: 'renewals', builder: (context, state) => const _DeferredFeature(title: 'Renewals', phase: 11)),
          ])]),
        ],
      ),
    ],
  );
});

class _DeferredFeature extends StatelessWidget {
  const _DeferredFeature({required this.title, required this.phase});
  final String title;
  final int phase;
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text('$title is scheduled for Phase $phase.')));
}
