import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class FavoriteRepository {
  final Dio dio;

  FavoriteRepository({required this.dio});

  Future<void> addFavorite(int productId, {CancelToken? cancelToken}) async {
    try {
      await dio.post(
        '/favorites/$productId',
        data: {'productId': productId},
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(int productId, {CancelToken? cancelToken}) async {
    try {
      await dio.delete('/favorites/$productId', cancelToken: cancelToken);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error removing favorite: $e');
    }
  }

  Future<({List<ProductModel> items, int count})> getFavorites({
    int limit = 30,
    int skip = 0,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/favorites',
        queryParameters: {'limit': limit, 'skip': skip},
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List;
      final count = body['count'] as int? ?? 0;
      final items = data
          .map(
            (e) => ProductModel.fromJson(
              (e as Map<String, dynamic>)['product'] as Map<String, dynamic>,
            ),
          )
          .toList();
      return (items: items, count: count);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching favorites: $e');
    }
  }
}
