import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../providers/today_providers.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(todaySnapshotProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: snapshot.when(
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorState(message: error.toString(), onRetry: () => ref.invalidate(todaySnapshotProvider)),
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.refresh(todaySnapshotProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text('Welcome, ${data.trainerName}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  _Metric(label: 'Active Clients', value: data.activeClients),
                  _Metric(label: 'Reviews Waiting', value: data.reviewsWaiting),
                  _Metric(label: 'Renewals', value: data.renewalsWaiting),
                  _Metric(label: 'Paused / Expired', value: data.pausedClients + data.expiredClients),
                ],
              ),
              const SizedBox(height: 20),
              Text('Needs your attention', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              if (data.reviewsWaiting > 0) _Attention(icon: Icons.fact_check_outlined, title: '${data.reviewsWaiting} check-ins waiting', onTap: () => context.push('/more/checkin-reviews')),
              if (data.renewalsWaiting > 0) _Attention(icon: Icons.autorenew, title: '${data.renewalsWaiting} renewal requests', onTap: () => context.push('/more/renewals')),
              if (data.expiredClients > 0) _Attention(icon: Icons.warning_amber, title: '${data.expiredClients} expired clients', onTap: () => context.go('/clients')),
              if (data.reviewsWaiting == 0 && data.renewalsWaiting == 0 && data.expiredClients == 0) const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('You are all caught up.'))),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[Text('Recent Clients', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)), TextButton(onPressed: () => context.go('/clients'), child: const Text('View all'))]),
              ...data.recentClients.map((client) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Text(client.name.isEmpty ? '?' : client.name[0])),
                    title: Text(client.name),
                    subtitle: Text(client.goal),
                    trailing: Text(client.status),
                    onTap: () => context.push('/clients/${client.id}'),
                  )),
              const SizedBox(height: 20),
              Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: <Widget>[
                ActionChip(avatar: const Icon(Icons.person_add_alt_1), label: const Text('Add Client'), onPressed: () => context.push('/clients/new')),
                ActionChip(avatar: const Icon(Icons.fitness_center), label: const Text('Workout Templates'), onPressed: () => context.go('/programs')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Text('$value', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)), Text(label)])));
}

class _Attention extends StatelessWidget {
  const _Attention({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: onTap));
}
