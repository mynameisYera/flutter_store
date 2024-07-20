class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final List imageUrl;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      rating: json['rating'],
    );
  }
}
