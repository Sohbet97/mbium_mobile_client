import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/reels/models/gift_model.dart';

enum GiftSendErrorType { invalidRequest, notFound, unknown }

class GiftSendException implements Exception {
  final GiftSendErrorType type;
  final String message;

  const GiftSendException(this.type, this.message);

  @override
  String toString() => message;
}

class GiftRepository {
  final Dio dio;

  GiftRepository({required this.dio});

  Future<List<GiftTypeModel>> getGiftTypes({CancelToken? cancelToken}) async {
    final response = await dio.get(
      '/reels/gift-types',
      cancelToken: cancelToken,
    );

    if (response.statusCode != 200) {
      throw Exception('status code: ${response.statusCode}');
    }

    final data = (response.data as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => GiftTypeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GiftsResponse> getReelGifts(
    int reelId, {
    int page = 1,
    int limit = 20,
    CancelToken? cancelToken,
  }) async {
    final response = await dio.get(
      '/reels/$reelId/gifts',
      queryParameters: {'page': page, 'limit': limit},
      cancelToken: cancelToken,
    );

    if (response.statusCode != 200) {
      throw Exception('status code: ${response.statusCode}');
    }

    return GiftsResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<GiftModel> sendGift(
    int reelId, {
    required int giftTypeId,
    String? message,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        '/reels/$reelId/gifts',
        data: {
          'gift_type_id': giftTypeId,
          if (message != null) 'message': message,
        },
        cancelToken: cancelToken,
      );
      final body = response.data as Map<String, dynamic>;
      return GiftModel.fromJson(body['model'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;

      final status = e.response?.statusCode;
      final serverMessage = _extractMessage(e.response?.data);

      if (status == 400) {
        throw GiftSendException(
          GiftSendErrorType.invalidRequest,
          serverMessage ?? 'Ýeterlik balans ýok ýa-da sowgat görnüşi ýalňyş',
        );
      }
      if (status == 404) {
        throw GiftSendException(
          GiftSendErrorType.notFound,
          serverMessage ?? 'Reel ýa-da sowgat görnüşi tapylmady',
        );
      }
      throw GiftSendException(
        GiftSendErrorType.unknown,
        serverMessage ?? 'Sowgat ibermek başartmady',
      );
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String) return message;
      if (message is List) return message.join(', ');
    }
    return null;
  }
}
