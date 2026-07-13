class OrderModel {
  final int id;
  final String userId;
  final int shopId;
  final int status;
  final num totalPrice;
  final String currency;
  final String deliveryAddress;
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.status,
    required this.totalPrice,
    required this.currency,
    required this.deliveryAddress,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id']?.toString() ?? '',
      shopId: json['shop_id'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      totalPrice: (json['total_price'] as num?) ?? 0,
      currency: json['currency'] as String? ?? '',
      deliveryAddress: json['delivery_address'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
