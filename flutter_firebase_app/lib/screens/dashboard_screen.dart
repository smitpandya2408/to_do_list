import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/auth_providers.dart';
import '../services/firebase_service.dart';
import 'api_list_screen.dart';
import 'api_detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends ConsumerWidget {
  static const String routeName = '/dashboard';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNameAsync = ref.watch(userNameProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(firebaseServiceProvider).signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              userNameAsync.when(
                data: (name) => Text('Welcome, ${name ?? FirebaseAuth.instance.currentUser?.email ?? 'User'}!',
                    style: Theme.of(context).textTheme.headlineSmall),
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(ApiListScreen.routeName),
                icon: const Icon(Icons.list),
                label: const Text('Open Products List (API)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pushNamed(ApiDetailScreen.routeName),
                icon: const Icon(Icons.person),
                label: const Text('Open User Detail (API)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
