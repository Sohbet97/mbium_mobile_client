import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_history_model.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_topup_model.dart';
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

  Future<({List<CoinHistoryModel> items, int count})> getHistory({
    int page = 1,
    int limit = 30,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/coins/history',
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load coin history: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List;
      final count = body['count'] as int? ?? 0;
      final items = data
          .map((e) => CoinHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (items: items, count: count);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching coin history: $e');
    }
  }

  Future<CoinTopupModel> requestTopup({
    required double amountTmt,
    String? receiptUrl,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/coins/topup',
        data: {'amount_tmt': amountTmt, 'receipt_url': receiptUrl},
        cancelToken: cancelToken,
      );

      if (response.statusCode == 201) {
        return CoinTopupModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw Exception(
        (response.data as Map<String, dynamic>?)?['message'] ??
            'Failed to request coin top-up: ${response.statusCode}',
      );
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      final message = (e.response?.data as Map<String, dynamic>?)?['message'];
      throw Exception(message ?? 'Error requesting coin top-up: $e');
    }
  }

  Future<({List<CoinTopupModel> items, int count})> getTopupRequests({
    int page = 1,
    int limit = 30,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/coins/topup',
        queryParameters: {'page': page, 'limit': limit},
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load coin top-up requests: ${response.statusCode}',
        );
      }

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List;
      final count = body['count'] as int? ?? 0;
      final items = data
          .map((e) => CoinTopupModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (items: items, count: count);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching coin top-up requests: $e');
    }
  }
}
