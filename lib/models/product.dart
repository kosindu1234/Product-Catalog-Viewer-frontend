class Product {
  final int id;
  final String name;
  final double price;
  final String description;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
    );
  }
}