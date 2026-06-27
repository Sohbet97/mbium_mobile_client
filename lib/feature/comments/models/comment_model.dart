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

  factory CommentAuthor.fromJson(Map<String, dynamic> json) {
    return CommentAuthor(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      surname: json['surname'] as String? ?? '',
      thumbnail: json['thumbnail'] as String?,
    );
  }

  String get fullName => '$name $surname'.trim();
}

class CommentModel {
  final int id;
  final int productId;
  final String userId;
  final int? parentId;
  final String body;
  final String status;
  final CommentAuthor author;
  final List<CommentModel> replies;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.productId,
    required this.userId,
    this.parentId,
    required this.body,
    required this.status,
    required this.author,
    this.replies = const [],
    required this.createdAt,
  });

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isReply => parentId != null;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    List<CommentModel> parseReplies(dynamic raw) {
      if (raw == null) return [];
      if (raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(CommentModel.fromJson)
          .toList();
    }

    return CommentModel(
      id: json['id'] as int,
      productId: json['product_id'] as int? ?? 0,
      userId: json['user_id']?.toString() ?? '',
      parentId: json['parent_id'] as int?,
      body: json['body'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      author: CommentAuthor.fromJson(
        json['author'] as Map<String, dynamic>? ?? {},
      ),
      replies: parseReplies(json['replies']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
