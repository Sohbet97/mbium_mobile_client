import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/sizes/models/size_filter.dart';
import 'package:mbium_mobile_client/feature/sizes/models/size_model.dart';

class SizeRepository {
  final Dio dio;

  SizeRepository({required this.dio});

  Future<({List<SizeModel> sizes, int count})> getSizes(
    SizeFilter filter, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/catalog/sizes',
        queryParameters: filter.toQueryParameters(),
        cancelToken: cancelToken,
      );

      if (response.statusCode == 200) {
        final body = response.data as Map<String, dynamic>;
        final data = body['data'] as List;
        final count = body['count'] as int? ?? data.length;
        final sizes = data
            .map((e) => SizeModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return (sizes: sizes, count: count);
      }

      throw Exception('Failed to load sizes: ${response.statusCode}');
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching sizes: $e');
    }
  }
}
