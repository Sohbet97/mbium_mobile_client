class CommentAuthor {
  final String id;
  final String name;
  final String surname;
  final String? thumbnail;

  const CommentAuthor({
    required this.id,
    required this.name,
    required this.surname,
    this.thumbnail,
  });

  factory CommentAuthor.fromUserId(String userId) {
    final masked = userId.isEmpty
        ? '???'
        : '${userId.substring(0, userId.length >= 4 ? 4 : userId.length)}***';
    return CommentAuthor(id: userId, name: masked, surname: '');
  }

  String get fullName => '$name $surname'.trim();
}

class CommentModel {
  final int id;
  final int productId;
  final int orderId;
  final String userId;
  final int rating;
  final String body;
  final int status;
  final CommentAuthor author;
  final List<CommentModel> replies;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.productId,
    required this.orderId,
    required this.userId,
    required this.rating,
    required this.body,
    required this.status,
    required this.author,
    this.replies = const [],
    required this.createdAt,
  });

  /// status: 0=pending, 1=approved, 2=rejected
  bool get isApproved => status == 1;
  bool get isPending => status == 0;
  bool get isRejected => status == 2;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final userId = json['user_id']?.toString() ?? '';

    return CommentModel(
      id: json['id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      orderId: json['order_id'] as int? ?? 0,
      userId: userId,
      rating: json['rating'] as int? ?? 0,
      body: json['comment'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      author: CommentAuthor.fromUserId(userId),
      replies: const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class CommentsResponse {
  final List<CommentModel> comments;
  final int count;

  const CommentsResponse({required this.comments, required this.count});

  bool hasMore(int skip, int limit) => skip + limit < count;

  factory CommentsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    return CommentsResponse(
      comments: data
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int? ?? data.length,
    );
  }
}

class CreateCommentRequest {
  final int productId;
  final int orderId;
  final int rating;
  final String comment;

  const CreateCommentRequest({
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