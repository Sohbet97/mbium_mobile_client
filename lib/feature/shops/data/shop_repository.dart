import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_filter_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_type_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shops_response.dart';

class ShopRepository {
  final Dio dio;

  ShopRepository({required this.dio});

  static List<ShopTypeModel>? _shopTypes;

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

  Future<ShopDetailModel> getShopDetail(
    int id, {
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/catalog/shops/$id',
      cancelToken: cancelToken,
    );

    if (response.statusCode == 200) {
      return ShopDetailResponse.fromJson(
        response.data as Map<String, dynamic>,
      ).model;
    }

    throw Exception('Failed to load shop detail: ${response.statusCode}');
  }

  Future<List<ShopTypeModel>> getShopTypes({CancelToken? cancelToken}) async {
    if (_shopTypes != null && _shopTypes!.isNotEmpty) {
      return _shopTypes!;
    }

    final response = await dio.get('/shop-types', cancelToken: cancelToken);

    if (response.statusCode == 200) {
      final shopTypes = ShopTypesResponse.fromJson(
        response.data as Map<String, dynamic>,
      ).shopTypes;
      _shopTypes = shopTypes;
      return shopTypes;
    }

    throw Exception('Failed to load shop types: ${response.statusCode}');
  }
}
