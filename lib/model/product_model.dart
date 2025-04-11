class ProductModel {
  final String title;
  final double price;
  final double rating;
  final String thumbnail;
  final String category;
  final List<String> tags;

  ProductModel({
    required this.title,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.category,
    required this.tags,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      title: json['title'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      thumbnail: json['thumbnail'],
      category: json['category'],
      tags: List<String>.from(json['tags']),
    );
  }
}
