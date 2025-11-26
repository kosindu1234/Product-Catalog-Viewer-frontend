import '../models/product.dart';
import '../services/api_clienr.dart';

class ProductRepository {
  final ApiClient _apiClient;

  ProductRepository(this._apiClient);

  Future<List<Product>> getProducts() async {
    final response = await _apiClient.get('/products');
    final data = response.data as List<dynamic>;
    return data
        .map((json) => Product.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProductById(int id) async {
    final response = await _apiClient.get('/products/$id');
    return Product.fromJson(response.data as Map<String, dynamic>);
  }
}