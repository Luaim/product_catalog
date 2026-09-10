class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      thumbnail: json['thumbnail'],
      images: List<String>.from(json['images']),
    );
  }
}
