import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/api_providers.dart';
import '../models/product.dart';

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchProducts();
});

class ApiListScreen extends ConsumerWidget {
  static const String routeName = '/api-list';
  const ApiListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: productsAsync.when(
        data: (products) => ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final p = products[index];
            return Card(
              child: ListTile(
                leading: p.imageUrl.isNotEmpty
                    ? Image.network(p.imageUrl, width: 56, height: 56, fit: BoxFit.cover)
                    : const Icon(Icons.image_not_supported),
                title: Text(p.title),
                subtitle: Text(
                  p.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Failed to load products. Error: $e'),
          ),
        ),
      ),
    );
  }
}
