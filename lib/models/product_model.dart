class Product {
  final String id;
  final String name;
  final double price;
  final String categoryId;
  final String imageUrl;
  final String description;
  final bool instock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.description,
    required this.instock,
  });

  // Factory method to create a Product from a map
  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      categoryId: data['categoryId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      instock: data['instock'] ?? false,
    );
  }
}
