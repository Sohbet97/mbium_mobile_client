class ReviewsResponse {
  final List<ReviewModel> reviews;
  final int count;

  const ReviewsResponse({required this.reviews, required this.count});

  bool hasMore(int skip, int limit) => skip + limit < count;

  factory ReviewsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    return ReviewsResponse(
      reviews: data
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int? ?? data.length,
    );
  }
}

/// status: 0=pending, 1=approved, 2=rejected
class ReviewModel {
  final int id;
  final String userId;
  final int productId;
  final int orderId;
  final int rating;
  final String comment;
  final int status;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.orderId,
    required this.rating,
    required this.comment,
    required this.status,
    required this.createdAt,
  });

  bool get isApproved => status == 1;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id']?.toString() ?? '',
      productId: json['product_id'] as int? ?? 0,
      orderId: json['order_id'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class CreateReviewRequest {
  final int productId;
  final int orderId;
  final int rating;
  final String comment;

  const CreateReviewRequest({
    required this.productId,
    required this.orderId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'order_id': orderId,
        'rating': rating,
        'comment': comment,
      };
}