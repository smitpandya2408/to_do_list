class Product {
  final int id;
  final String title;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image']?.toString() ?? json['thumbnail']?.toString() ?? '',
    );
  }
}
