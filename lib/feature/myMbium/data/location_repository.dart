import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/myMbium/models/location_model.dart';

class LocationRepository {
  final Dio dio;

  LocationRepository({required this.dio});

  Future<({List<RegionModel> items, int count})> getRegions({
    String? text,
    int limit = 30,
    int skip = 0,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/locations/regions',
        queryParameters: {
          if (text != null && text.isNotEmpty) 'text': text,
          'limit': limit,
          'skip': skip,
        },
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load regions: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List;
      final count = body['count'] as int? ?? 0;
      final items = data
          .map((e) => RegionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (items: items, count: count);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching regions: $e');
    }
  }

  Future<({List<CityModel> items, int count})> getCities({
    String? text,
    int? regionId,
    int limit = 30,
    int skip = 0,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/locations/cities',
        queryParameters: {
          if (text != null && text.isNotEmpty) 'text': text,
          if (regionId != null) 'region': regionId,
          'limit': limit,
          'skip': skip,
        },
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load cities: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List;
      final count = body['count'] as int? ?? 0;
      final items = data
          .map((e) => CityModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (items: items, count: count);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching cities: $e');
    }
  }
}
