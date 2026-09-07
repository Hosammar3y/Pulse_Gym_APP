import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        children: <Widget>[
          ListTile(title: const Text('Notifications'), trailing: const Icon(Icons.chevron_right), onTap: () => context.go('/more/notifications')),
        ],
      ),
    );
  }
}
