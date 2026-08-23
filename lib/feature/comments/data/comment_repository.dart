import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';

class CommentRepository {
  final Dio dio;

  CommentRepository({required this.dio});

  String _commentsPath(int productId) => '/catalog/products/$productId/comments';

  Future<CommentsResponse> getProductComments(
    int productId, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        _commentsPath(productId),
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200) {
        return CommentsResponse.fromJson(response.data);
      }

      throw Exception('Failed to load comments: ${response.statusCode}');
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching comments: $e');
    }
  }

  Future<CommentModel> createComment(CreateCommentRequest request) async {
    final response = await dio.post(
      _commentsPath(request.productId),
      data: request.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = response.data as Map<String, dynamic>;
      // The server doesn't always wrap the created comment in `data` —
      // fall back to the raw body when that key is absent.
      final data = body['data'] as Map<String, dynamic>? ?? body;
      return CommentModel.fromJson(data);
    }

    throw Exception('Failed to create comment: ${response.statusCode}');
  }
}
