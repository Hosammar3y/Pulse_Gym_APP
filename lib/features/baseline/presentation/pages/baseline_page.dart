import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../domain/entities/starting_baseline.dart';
import '../providers/baseline_providers.dart';

class BaselinePage extends ConsumerStatefulWidget {
  const BaselinePage({required this.clientId, super.key});
  final String clientId;

  @override
  ConsumerState<BaselinePage> createState() => _BaselinePageState();
}

class _BaselinePageState extends ConsumerState<BaselinePage> {
  final _weight = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _weight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(startingBaselineProvider(widget.clientId));
    final mutation = ref.watch(baselineMutationControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Starting Baseline')),
      body: value.when(
        loading: () => const AppLoading(),
        error: (error, _) => AppErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(startingBaselineProvider(widget.clientId)),
        ),
        data: (baseline) {
          if (_weight.text.isEmpty && baseline.startingWeightKg != null) {
            _weight.text = baseline.startingWeightKg!.toStringAsFixed(1);
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              _statusLabel(baseline.status),
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          if (baseline.completed) const Icon(Icons.verified, color: Colors.green),
                        ],
                      ),
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
              const SizedBox(height: 4),
              const Text('Add and confirm Front, Side, and Back photos. Confirmed photos can be previewed securely.'),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth >= 560 ? (constraints.maxWidth - 24) / 3 : constraints.maxWidth;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: BaselineAngle.values
                        .map((angle) => SizedBox(
                              width: width,
                              child: _PhotoCard(
                                angle: angle,
                                photo: _photoFor(baseline, angle),
                                readOnly: baseline.completed,
                                busy: mutation.isLoading,
                                onAdd: () => _pickAndUpload(angle),
                                onPreview: (photo) => _preview(photo),
                                onRemove: (photo) => _remove(photo),
                              ),
                            ))
                        .toList(growable: false),
                  );
                },
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Complete baseline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 6),
                      Text(
                        baseline.completed
                            ? 'This Starting Baseline is complete and read-only.'
                            : 'Completion requires confirmed FRONT, SIDE, and BACK photos and a positive starting weight.',
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _weight,
                        enabled: !baseline.completed && !mutation.isLoading,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(labelText: 'Starting weight (kg)', border: OutlineInputBorder()),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: baseline.completed || mutation.isLoading || !baseline.allRequiredPhotosConfirmed ? null : _complete,
                          icon: mutation.isLoading
                              ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.check_circle_outline),
                          label: Text(baseline.completed ? 'Completed' : 'Complete Starting Baseline'),
                        ),
                      ),
                      if (mutation.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(mutation.error.toString(), style: TextStyle(color: Theme.of(context).colorScheme.error)),
                        ),
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
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.history),
                        title: Text('Previous Reviewed Check-in'),
                        subtitle: Text('Used from the Check-in review flow.'),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.flag_outlined),
                        title: Text('Client Start'),
                        subtitle: Text('Uses this permanent Starting Baseline.'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  StartingBaselinePhoto? _photoFor(StartingBaseline baseline, BaselineAngle angle) {
    for (final photo in baseline.photos) {
      if (photo.angle == angle) return photo;
    }
    return null;
  }

  Future<void> _pickAndUpload(BaselineAngle angle) async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 92);
    if (file == null || !mounted) return;
    final bytes = await file.readAsBytes();
    final contentType = file.mimeType ?? _contentType(file.name);
    final ok = await ref.read(baselineMutationControllerProvider.notifier).upload(
          widget.clientId,
          angle,
          bytes,
          contentType,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ok ? '${angle.apiValue} photo confirmed.' : 'Photo upload failed. Nothing was confirmed.')),
    );
  }

  Future<void> _preview(StartingBaselinePhoto photo) async {
    try {
      final uri = await ref.read(baselineRepositoryProvider).getPhotoReadUri(widget.clientId, photo.id);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (context) => Dialog.fullscreen(
          child: Scaffold(
            appBar: AppBar(
              title: Text('${photo.angle.apiValue} photo'),
              leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
            ),
            body: ColoredBox(
              color: Colors.black,
              child: Center(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 4,
                  child: Image.network(uri.toString(), fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.white, size: 54)),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not open photo: $error')));
    }
  }

  Future<void> _remove(StartingBaselinePhoto photo) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Remove ${photo.angle.apiValue} photo?'),
            content: const Text('You can upload another photo for this angle afterwards.'),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
            ],
          ),
        ) ??
        false;
    if (!confirmed) return;
    await ref.read(baselineMutationControllerProvider.notifier).remove(widget.clientId, photo.id);
  }

  Future<void> _complete() async {
    final value = double.tryParse(_weight.text.trim());
    if (value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a positive starting weight.')));
      return;
    }
    final ok = await ref.read(baselineMutationControllerProvider.notifier).complete(widget.clientId, value);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Starting Baseline completed.' : 'Could not complete Starting Baseline.')));
  }

  String _statusLabel(String status) => switch (status) {
        'COMPLETED' => 'Completed',
        'IN_PROGRESS' => 'In progress',
        _ => 'Not started',
      };

  String _contentType(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.angle,
    required this.photo,
    required this.readOnly,
    required this.busy,
    required this.onAdd,
    required this.onPreview,
    required this.onRemove,
  });

  final BaselineAngle angle;
  final StartingBaselinePhoto? photo;
  final bool readOnly;
  final bool busy;
  final VoidCallback onAdd;
  final ValueChanged<StartingBaselinePhoto> onPreview;
  final ValueChanged<StartingBaselinePhoto> onRemove;

  @override
  Widget build(BuildContext context) {
    final confirmed = photo?.uploadConfirmed == true;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(confirmed ? Icons.check_circle : Icons.image_outlined),
                const SizedBox(width: 8),
                Expanded(child: Text(angle.apiValue, style: const TextStyle(fontWeight: FontWeight.w800))),
                Text(confirmed ? 'Confirmed' : 'Missing'),
              ],
            ),
            const SizedBox(height: 12),
            if (confirmed) ...<Widget>[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: busy ? null : () => onPreview(photo!),
                  icon: const Icon(Icons.zoom_in),
                  label: const Text('Open photo'),
                ),
              ),
              if (!readOnly)
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: busy ? null : () => onRemove(photo!),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remove'),
                  ),
                ),
            ] else if (!readOnly)
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: busy ? null : onAdd,
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text('Add photo'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
