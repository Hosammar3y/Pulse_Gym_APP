import 'package:flutter/material.dart';
import '../../domain/entities/client.dart';

class ClientCard extends StatelessWidget {
  const ClientCard({required this.client, required this.onTap, super.key});
  final Client client;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(child: Text(client.firstName.isEmpty ? '?' : client.firstName[0].toUpperCase())),
          title: Text(client.displayName, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${client.goal} • ${client.status.name.toUpperCase()}'),
          trailing: const Icon(Icons.chevron_right),
        ),
      );
}
