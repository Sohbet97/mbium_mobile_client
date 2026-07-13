import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/cupons/models/my_coin_model.dart';

class CoinRepository {
  final Dio dio;

  CoinRepository({required this.dio});

  Future<MyCoinModel> getBalance({CancelToken? cancelToken}) async {
    try {
      final response = await dio.get(
        '/coins/balance',
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load coin balance: ${response.statusCode}');
      }

      final body = response.data;
      final data = body is Map<String, dynamic> && body['data'] is Map
          ? body['data'] as Map<String, dynamic>
          : body as Map<String, dynamic>;
      return MyCoinModel.fromJson(data);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching coin balance: $e');
    }
  }
}
