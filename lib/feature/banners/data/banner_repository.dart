import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/banners/model/banner_model.dart';

class BannerRepository {
  final Dio dio;

  BannerRepository({required this.dio});

  Future<List<BannerModel>> getBanners({
    String? type,
    int? shopId,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/banners',
      queryParameters: {'type': ?type, 'shop_id': ?shopId},
      cancelToken: cancelToken,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load banners: ${response.statusCode}');
    }

    final data = response.data['data'] as List? ?? [];
    return data
        .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
