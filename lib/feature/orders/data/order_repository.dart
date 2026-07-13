import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/orders/model/order_filter.dart';
import 'package:mbium_mobile_client/feature/orders/model/order_model.dart';

class OrderRepository {
  final Dio dio;
  final AppPreferences preferences;

  OrderRepository({required this.dio, required this.preferences});

  Future<({List<OrderModel> orders, int count})> getOrders(
    OrderFilter filter, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        '/orders/',
        queryParameters: filter.toQueryParameters(),
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List;
      final count = body['count'] as int? ?? 0;
      final orders = data
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return (orders: orders, count: count);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching orders: $e');
    }
  }

  /// POST /orders/ — creates order(s) from the given payload (eg. cart
  /// checkout). The backend can split a single checkout into several orders
  /// (one per shop), so it returns a list, mirroring the GET list shape.
  Future<List<OrderModel>> createOrders(
    Map<String, dynamic> payload, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/orders/',
        data: payload,
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create order: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List;
      return data
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error creating order: $e');
    }
  }

  Future<OrderModel> getOrder(int id, {CancelToken? cancelToken}) async {
    try {
      final response = await dio.get('/orders/$id', cancelToken: cancelToken);

      if (response.statusCode != 200) {
        throw Exception('Failed to load order: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final raw = (body['model'] ?? body) as Map<String, dynamic>;
      return OrderModel.fromJson(raw);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching order: $e');
    }
  }

  Future<void> cancelOrder(
    int id, {
    String? note,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/orders/$id/cancel',
        data: {'note': note ?? ''},
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to cancel order: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error cancelling order: $e');
    }
  }
}
