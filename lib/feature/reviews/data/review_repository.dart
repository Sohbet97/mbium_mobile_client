import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/reviews/models/review_model.dart';

class ReviewRepository {
  final Dio dio;

  ReviewRepository({required this.dio});

  Future<ReviewsResponse> getProductReviews({
    required int productId,
    int limit = 20,
    int skip = 0,
    int status = 1,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/admin/reviews',
      queryParameters: {
        'product_id': productId,
        'status': status,
        'limit': limit,
        'skip': skip,
      },
      cancelToken: cancelToken,
    );

    if (response.statusCode == 200) {
      return ReviewsResponse.fromJson(response.data as Map<String, dynamic>);
    }

    throw Exception('Failed to load reviews: ${response.statusCode}');
  }

  Future<ReviewModel> createReview(CreateReviewRequest request) async {
    final response = await dio.post('/admin/reviews', data: request.toJson());

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = response.data as Map<String, dynamic>;
      final model = data['model'] as Map<String, dynamic>? ?? data;
      return ReviewModel.fromJson(model);
    }

    throw Exception('Failed to create review: ${response.statusCode}');
  }
}