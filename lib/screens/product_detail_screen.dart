import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)!.settings.arguments;

    if (args == null || args is! int) {
      return const Scaffold(
        body: Center(
          child: Text('No product ID provided.'),
        ),
      );
    }

    final int id = args;
    final productAsync = ref.watch(productDetailsProvider(id));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Product Details',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: productAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => _ErrorView(id: id, error: error),
        data: (product) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top summary card
              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + optional badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Price pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08),
                        ),
                        child: Text(
                          'LKR ${product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              
              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ).borderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description.isNotEmpty
                            ? product.description
                            : 'No description available for this product.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  final int id;
  final Object error;

  const _ErrorView({
    required this.id,
    required this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            const Text(
              'Failed to load product details.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 130,
              child: FilledButton(
                onPressed: () {
                  ref.invalidate(productDetailsProvider(id));
                },
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}