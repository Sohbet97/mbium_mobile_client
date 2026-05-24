import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/products_response.dart';

class ProductRepository {
  final Dio dio;

  ProductRepository({required this.dio});

  Future<ProductsResponse> getProducts(
    FilterModel filter, {
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/catalog/products',
      queryParameters: filter.toQueryParameters(),
      cancelToken: cancelToken,
    );

    if (response.statusCode == 200) {
      return ProductsResponse.fromJson(response.data as Map<String, dynamic>);
    }

    throw Exception('Failed to load products: ${response.statusCode}');
  }
}
