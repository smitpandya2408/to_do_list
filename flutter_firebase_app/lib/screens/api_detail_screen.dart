import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_providers.dart';

final userDetailProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchUserDetail();
});

class ApiDetailScreen extends ConsumerWidget {
  static const String routeName = '/api-detail';
  const ApiDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('User Detail')),
      body: userAsync.when(
        data: (data) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _field('Name', data['name']?.toString() ?? ''),
                _field('Username', data['username']?.toString() ?? ''),
                _field('Email', data['email']?.toString() ?? ''),
                _field('Phone', data['phone']?.toString() ?? ''),
                _field('Website', data['website']?.toString() ?? ''),
                _field('Company', data['company']?['name']?.toString() ?? ''),
                _field('City', data['address']?['city']?.toString() ?? ''),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Failed to load user. Error: $e'),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
