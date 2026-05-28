import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

class ShopsResponse {
  final List<ShopModel> shops;
  final int count;

  const ShopsResponse({
    required this.shops,
    required this.count,
  });

  bool hasMore(int page, int limit) => page * limit < count;

  factory ShopsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return ShopsResponse(
      shops: data
          .map((e) => ShopModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int? ?? data.length,
    );
  }
}
