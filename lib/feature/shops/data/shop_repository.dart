import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_filter_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shops_response.dart';

class ShopRepository {
  final Dio dio;

  ShopRepository({required this.dio});

  Future<ShopsResponse> getShops(
    ShopFilterModel filter, {
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/catalog/shops',
      queryParameters: filter.toQueryParameters(),
      cancelToken: cancelToken,
    );

    if (response.statusCode == 200) {
      return ShopsResponse.fromJson(response.data as Map<String, dynamic>);
    }

    throw Exception('Failed to load shops: ${response.statusCode}');
  }
}
