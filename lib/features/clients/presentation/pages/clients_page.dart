import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../providers/clients_providers.dart';
import '../widgets/client_card.dart';

class ClientsPage extends ConsumerWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider);
    final status = ref.watch(clientsStatusProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/clients/new'),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Client'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(clientsProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search clients'),
              onChanged: (value) => ref.read(clientsQueryProvider.notifier).state = value.trim(),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['ALL', 'ACTIVE', 'INVITED', 'PAUSED', 'EXPIRED']
                    .map((value) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(value),
                            selected: status == value,
                            onSelected: (_) => ref.read(clientsStatusProvider.notifier).state = value,
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            clients.when(
              loading: () => const AppLoading(),
              error: (error, _) => AppErrorState(message: error.toString(), onRetry: () => ref.invalidate(clientsProvider)),
              data: (items) => items.isEmpty
                  ? const AppEmptyState(title: 'No clients found', message: 'Try another search or add your first client.')
                  : Column(
                      children: items.map((client) => ClientCard(client: client, onTap: () => context.push('/clients/${client.id}'))).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
