import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_filter_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_response.dart';

class ReelsRepository {
  final Dio dio;

  ReelsRepository({required this.dio});

  Future<ReelsResponse> getReels(
    ReelsFilterModel filter, {
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/reels',
      queryParameters: filter.toQueryParameters(),
      cancelToken: cancelToken,
    );

    if (response.statusCode != 200) {
      throw Exception('status code: ${response.statusCode}');
    }

    return ReelsResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
