import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_empty_state.dart';

class NotificationCenterPage extends StatelessWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: AppEmptyState(
          title: 'No notifications loaded',
          message: 'Realtime notification presentation will be completed in its dedicated phase.',
        ),
      );
}
