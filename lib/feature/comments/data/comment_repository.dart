import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';

class CommentRepository {
  final Dio dio;

  CommentRepository({required this.dio});

  Future<List<CommentModel>> getProductComments(
    int productId, {
    int limit = 20,
    int skip = 0,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/catalog/products/$productId/comments',
        queryParameters: {'limit': limit, 'skip': skip},
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data
            .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw Exception('Failed to load comments: ${response.statusCode}');
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching comments: $e');
    }
  }
}
