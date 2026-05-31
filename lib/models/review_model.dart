class ProductReview {
  final String id;
  final String userName;
  final double rating;
  final String date;
  final String comment;
  final String? userAvatar;

  const ProductReview({
    required this.id,
    required this.userName,
    required this.rating,
    required this.date,
    required this.comment,
    this.userAvatar,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] as String,
      userName: json['userName'] ?? json['user_name'] as String,
      rating: (json['rating'] as num).toDouble(),
      date: json['date'] as String,
      comment: json['comment'] as String,
      userAvatar: json['userAvatar'] ?? json['user_avatar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'rating': rating,
      'date': date,
      'comment': comment,
      'userAvatar': userAvatar,
    };
  }
}
