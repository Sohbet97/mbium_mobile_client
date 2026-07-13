import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/myMbium/models/address_model.dart';

class AddressRepository {
  final Dio dio;

  AddressRepository({required this.dio});

  Future<List<AddressModel>> getAddresses({CancelToken? cancelToken}) async {
    try {
      final response = await dio.get(
        '/addresses',
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load addresses: ${response.statusCode}');
      }

      final data = (response.data as Map<String, dynamic>)['data'] as List;
      return data
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error fetching addresses: $e');
    }
  }

  Future<AddressModel> createAddress(
    AddressModel address, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/addresses',
        data: address.toJson(),
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create address: ${response.statusCode}');
      }

      final body = response.data as Map<String, dynamic>;
      final raw = (body['model'] ?? body) as Map<String, dynamic>;
      return AddressModel.fromJson(raw);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error creating address: $e');
    }
  }

  Future<void> updateAddress(
    int id,
    AddressModel address, {
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.put(
        '/addresses/$id',
        data: address.toJson(),
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update address: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error updating address: $e');
    }
  }

  Future<void> deleteAddress(int id, {CancelToken? cancelToken}) async {
    try {
      final response = await dio.delete(
        '/addresses/$id',
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete address: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw Exception('Error deleting address: $e');
    }
  }
}
