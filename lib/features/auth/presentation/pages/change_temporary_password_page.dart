import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_providers.dart';

class ChangeTemporaryPasswordPage extends ConsumerStatefulWidget {
  const ChangeTemporaryPasswordPage({super.key});

  @override
  ConsumerState<ChangeTemporaryPasswordPage> createState() => _ChangeTemporaryPasswordPageState();
}

class _ChangeTemporaryPasswordPageState extends ConsumerState<ChangeTemporaryPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challenge = ref.watch(temporaryPasswordChallengeProvider);
    final auth = ref.watch(authControllerProvider);
    if (challenge == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/login');
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Change temporary password')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'Set your new password',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      challenge == null
                          ? 'Your temporary-password session is no longer available.'
                          : 'Your temporary password must be replaced before you can use Pulse Coach.',
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      key: const Key('temporary_new_password'),
                      controller: _password,
                      obscureText: _obscurePassword,
                      autofillHints: const <String>[AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: 'New password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'New password is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const Key('temporary_confirm_password'),
                      controller: _confirm,
                      obscureText: _obscureConfirm,
                      autofillHints: const <String>[AutofillHints.newPassword],
                      decoration: InputDecoration(
                        labelText: 'Confirm new password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Confirmation is required';
                        if (value != _password.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    if (auth.hasError) ...<Widget>[
                      const SizedBox(height: 12),
                      Text(
                        'Could not change the temporary password. Please review the password requirements and try again.',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton(
                      key: const Key('temporary_password_submit'),
                      onPressed: auth.isLoading || challenge == null ? null : () => _submit(challenge),
                      child: Text(auth.isLoading ? 'Saving…' : 'Change password'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      key: const Key('temporary_password_logout'),
                      onPressed: auth.isLoading ? null : _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Log out'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(TemporaryPasswordChallenge challenge) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final success = await ref
        .read(authControllerProvider.notifier)
        .completeTemporaryPassword(challenge, _password.text);
    if (!mounted || !success) return;
    _password.clear();
    _confirm.clear();
    context.go('/login');
  }

  Future<void> _logout() async {
    try {
      await ref.read(authControllerProvider.notifier).logout();
    } catch (_) {
      // The controller still clears local auth/challenge state in its finally block.
    } finally {
      _password.clear();
      _confirm.clear();
      if (mounted) context.go('/login');
    }
  }
}
