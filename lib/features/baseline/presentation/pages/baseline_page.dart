import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../providers/baseline_providers.dart';

class BaselinePage extends ConsumerWidget {
  const BaselinePage({required this.clientId, super.key});
  final String clientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(startingBaselineProvider(clientId));
    return Scaffold(
      appBar: AppBar(title: const Text('Starting Baseline')),
      body: value.when(
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorState(message: error.toString(), onRetry: () => ref.invalidate(startingBaselineProvider(clientId))),
        data: (baseline) => ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(baseline.status, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Requirement: ${baseline.requirement}'),
                    Text('Starting weight: ${baseline.startingWeightKg?.toStringAsFixed(1) ?? '—'} kg'),
                    Text('Completed: ${baseline.completedAt?.toLocal().toString() ?? '—'}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Photos', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const <String>['FRONT', 'SIDE', 'BACK'].map((angle) {
                final exists = baseline.photos.any((photo) => photo.angle.name.toUpperCase() == angle && photo.uploadConfirmed);
                return Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Theme.of(context).colorScheme.surfaceContainerHighest),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[Icon(exists ? Icons.check_circle : Icons.image_not_supported_outlined), const SizedBox(height: 8), Text(angle)]),
                );
              }).toList(growable: false),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Trainer-entered baseline', style: TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    const Text('Designed for mobile, but intentionally not wired because the production backend currently exposes trainer read access only. No fake local completion is allowed.'),
                    const SizedBox(height: 12),
                    FilledButton.icon(onPressed: null, icon: const Icon(Icons.add_a_photo_outlined), label: const Text('Complete baseline for client')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Comparison references', style: TextStyle(fontWeight: FontWeight.w800)),
                    SizedBox(height: 8),
                    ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.history), title: Text('Previous Reviewed Check-in'), subtitle: Text('Used from the check-in review flow.')),
                    ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.flag_outlined), title: Text('Client Start'), subtitle: Text('Uses this permanent starting baseline.')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
