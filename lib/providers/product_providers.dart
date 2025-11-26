import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../services/api_clienr.dart';
import '../repositories/product_repository.dart';


final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});


final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final client = ref.watch(apiClientProvider);
  return ProductRepository(client);
});

/// Fetch all products (AsyncValue<List<Product>>)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProducts();
});

/// Fetch a single product by id (AsyncValue<Product>)
final productDetailsProvider =
    FutureProvider.family<Product, int>((ref, id) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProductById(id);
});


final searchQueryProvider = StateProvider<String>((ref) => '');


final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase().trim();

  return productsAsync.whenData((products) {
    if (query.isEmpty) return products;
    return products
        .where((p) =>
            p.name.toLowerCase().contains(query) ||
            p.description.toLowerCase().contains(query))
        .toList();
  });
});