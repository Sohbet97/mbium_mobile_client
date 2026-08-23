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
  final int parentId;
  final String userId;
  final String body;
  final String status;
  final CommentAuthor author;
  final List<CommentModel> replies;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.productId,
    required this.parentId,
    required this.userId,
    required this.body,
    required this.status,
    required this.author,
    this.replies = const [],
    required this.createdAt,
  });

  bool get isApproved => status == 'approved';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';
  bool get isReply => parentId != 0;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      parentId: json['parent_id'] as int? ?? 0,
      userId: json['user_id']?.toString() ?? '',
      body: json['body'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      author: json['author'] is Map<String, dynamic>
          ? CommentAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : const CommentAuthor(id: '', name: '', surname: ''),
      // The API's Swagger example shows `replies` as a list of plain
      // strings, but real replies are nested comment objects — parse
      // defensively and skip anything that isn't one.
      replies: (json['replies'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map(CommentModel.fromJson)
              .toList() ??
          const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class CommentsResponse {
  final List<CommentModel> comments;

  const CommentsResponse({required this.comments});

  factory CommentsResponse.fromJson(dynamic json) {
    // The server has been observed to omit the `data` wrapper on some
    // responses — accept either a bare list or {"data": [...]}.
    final list = json is List
        ? json
        : (json as Map<String, dynamic>)['data'] as List? ?? [];
    return CommentsResponse(
      comments: list
          .whereType<Map<String, dynamic>>()
          .map(CommentModel.fromJson)
          .toList(),
    );
  }
}

class CreateCommentRequest {
  final int productId;
  final String body;
  final int parentId;

  const CreateCommentRequest({
    required this.productId,
    required this.body,
    this.parentId = 0,
  });

  Map<String, dynamic> toJson() => {
        'body': body,
        'parent_id': parentId,
      };
}
