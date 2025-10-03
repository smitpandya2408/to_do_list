import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modern_flutter_app/providers/auth_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final String name = auth.value?.userName ?? 'User';

    return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                tooltip: 'Logout',
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout),
              )
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome, $name', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      children: [
                        _ActionCard(
                          icon: Icons.store_outlined,
                          title: 'Products',
                          subtitle: 'Browse products from Fake Store API',
                          onTap: () => context.go('/products'),
                        ),
                        _ActionCard(
                          icon: Icons.person_outline,
                          title: 'Random User',
                          subtitle: 'Get a random user profile',
                          onTap: () => context.go('/user'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: color.primaryContainer, borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.all(12),
                child: Icon(icon, color: color.onPrimaryContainer, size: 28),
              ),
              const Spacer(),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
