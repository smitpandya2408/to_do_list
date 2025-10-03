import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_flutter_app/providers/auth_providers.dart';
import 'package:modern_flutter_app/widgets/ui.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
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

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier).login(
          _emailCtrl.text.trim(),
          _passwordCtrl.text,
        );
    if (!mounted) return;
    if (ok) {
      context.go('/dashboard');
    } else {
      final err = ref.read(authControllerProvider).value?.error ?? 'Login failed';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme;

    final authAsync = ref.watch(authControllerProvider);

    // Auto-redirect if already logged in
    final isLoggedIn = authAsync.value?.isLoggedIn == true;
    if (isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/dashboard');
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.flutter_dash, size: 72, color: color.primary),
                  const SizedBox(height: 12),
                  Text('Welcome back', style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
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
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: 'Login',
                              isLoading: authAsync.value?.isLoading == true,
                              onPressed: _onLogin,
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: const Text('Register'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
