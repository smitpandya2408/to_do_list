import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_flutter_app/providers/auth_providers.dart';
import 'package:modern_flutter_app/widgets/ui.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.isEmpty) return 'Name is required';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Min 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v != _passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _onRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier).register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
    if (!mounted) return;
    if (ok) {
      context.go('/dashboard');
    } else {
      final err = ref.read(authControllerProvider).value?.error ?? 'Registration failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          controller: _nameCtrl,
                          label: 'Name',
                          validator: _validateName,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _emailCtrl,
                          label: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _passwordCtrl,
                          label: 'Password',
                          obscureText: true,
                          validator: _validatePassword,
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        const SizedBox(height: 12),
                        AppTextField(
                          controller: _confirmCtrl,
                          label: 'Confirm Password',
                          obscureText: true,
                          validator: _validateConfirm,
                          prefixIcon: const Icon(Icons.lock_reset),
                        ),
                        const SizedBox(height: 16),
                        Consumer(builder: (context, ref, _) {
                          final async = ref.watch(authControllerProvider);
                          return PrimaryButton(
                            text: 'Register',
                            isLoading: async.value?.isLoading == true,
                            onPressed: _onRegister,
                          );
                        }),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text('Already have an account? Login'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
