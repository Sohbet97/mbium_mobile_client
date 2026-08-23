import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';

class CommentRepository {
  final Dio dio;

  static const String _reviewsBaseUrl = 'https://mbium.com/api/admin/reviews';

  CommentRepository({required this.dio});

  Future<CommentsResponse> getProductComments(
    int productId, {
    int limit = 20,
    int skip = 0,
    int status = 1,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        _reviewsBaseUrl,
        queryParameters: {
          'product_id': productId,
          'status': status,
          'limit': limit,
          'skip': skip,
        },
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200) {
        return CommentsResponse.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception('Failed to load comments: ${response.statusCode}');
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching comments: $e');
    }
  }

  Future<CommentModel> createComment(CreateCommentRequest request) async {
    final response = await dio.post(_reviewsBaseUrl, data: request.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data as Map<String, dynamic>;
      final model = data['model'] as Map<String, dynamic>? ?? data;
      return CommentModel.fromJson(model);
    }

    throw Exception('Failed to create comment: ${response.statusCode}');
  }
}