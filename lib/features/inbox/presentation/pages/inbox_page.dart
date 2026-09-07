import 'package:flutter/material.dart';
import '../../../../shared/widgets/app_empty_state.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: AppEmptyState(
          title: 'Inbox arrives in the Ticket phase',
          message: 'The ticket module will preserve the production Ask Coach model: text replies only, no attachments or suggested answers.',
        ),
      );
}
