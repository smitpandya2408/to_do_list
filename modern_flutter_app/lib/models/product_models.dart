class Product {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final num price;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: (json['id'] as num).toInt(),
        title: json['title'] as String,
        description: json['description'] as String,
        imageUrl: json['image'] as String,
        price: json['price'] as num,
      );
}
