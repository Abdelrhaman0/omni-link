class ProductModel {
  final int id;
  final String name;
  final String image;
  final double price;
  final double oldPrice;
  final String category;
  final int rating;

  ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'].toDouble(),
      oldPrice: json['old_price'].toDouble(),
      category: json['category'],
      rating: json['rating'] ,
    );
  }
}