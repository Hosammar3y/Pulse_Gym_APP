import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/storage/login_preferences.dart';
import '../providers/auth_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.text = ref.read(loginPreferencesProvider).readLastLoginEmail() ?? '';
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(Icons.bolt, size: 52, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Pulse Coach', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    const Text('Trainer workspace', textAlign: TextAlign.center),
                    const SizedBox(height: 32),
                    TextFormField(
                      key: const Key('login_email'),
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const <String>[AutofillHints.username, AutofillHints.email],
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) => value == null || value.trim().isEmpty ? 'Email is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const Key('login_password'),
                      controller: _password,
                      obscureText: true,
                      autofillHints: const <String>[AutofillHints.password],
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) => value == null || value.isEmpty ? 'Password is required' : null,
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      key: const Key('login_submit'),
                      onPressed: auth.isLoading ? null : _submit,
                      child: Text(auth.isLoading ? 'Signing in…' : 'Sign In'),
                    ),
                    if (auth.hasError) Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text('Sign in failed. Check your credentials and try again.', style: TextStyle(color: Theme.of(context).colorScheme.error)),
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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final result = await ref.read(authControllerProvider.notifier).login(_email.text.trim(), _password.text);
    if (!mounted || result == null) return;
    _password.clear();
    if (result.passwordChangeRequired) {
      context.go('/change-temporary-password');
      return;
    }
    context.go('/today');
  }
}
