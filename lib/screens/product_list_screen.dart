import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_providers.dart';
import '../models/product.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PRODUCT CATALOG',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          if (searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Results for "$searchQuery"',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: Colors.grey[700]),
                ),
              ),
            ),
          const SizedBox(height: 4),
          // Content
          Expanded(
            child: productsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => _ErrorView(error: error),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: products.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductListTile(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  final Object error;

  const _ErrorView({required this.error});

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
              'Something went wrong while loading products.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
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
                  ref.invalidate(productsProvider);
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

class _ProductListTile extends StatelessWidget {
  final Product product;

  const _ProductListTile({required this.product});

  @override
  Widget build(BuildContext context) {
    final priceStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        );

    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/details',
            arguments: product.id,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Simple avatar with first letter
              CircleAvatar(
                radius: 20,
                child: Text(
                  product.name.isNotEmpty ? product.name[0].toUpperCase() : '?',
                ),
              ),
              const SizedBox(width: 12),
              // Product info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LKR ${product.price.toStringAsFixed(2)}',
                      style: priceStyle,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}