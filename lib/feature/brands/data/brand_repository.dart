import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/brands/models/brand_filter.dart';
import 'package:mbium_mobile_client/feature/brands/models/brand_model.dart';

class BrandRepository {
  final Dio dio;

  BrandRepository({required this.dio});

  Future<({List<BrandModel> brands, int count})> getBrands(
    BrandFilter filter, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/catalog/brands',
        queryParameters: filter.toQueryParameters(),
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as List;
        final count = body['count'] as int? ?? 0;
        final brands = data
            .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return (brands: brands, count: count);
      }

      throw Exception('Failed to load brands: ${response.statusCode}');
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching brands: $e');
    }
  }
}
