num _parseNum(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v;
  return num.tryParse(v.toString()) ?? 0;
}

class OrderModel {
  final int id;
  final String userId;
  final int shopId;
  final int status;
  final num totalPrice;
  final String currency;
  final String deliveryAddress;
  final String note;
  final List<OrderItemModel> items;
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.shopId,
    required this.status,
    required this.totalPrice,
    required this.currency,
    required this.deliveryAddress,
    this.note = '',
    this.items = const [],
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int? ?? 0,
      userId: json['user_id']?.toString() ?? '',
      shopId: json['shop_id'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      // Backend sends this as a string (e.g. "54.50"), not a JSON number.
      totalPrice: _parseNum(json['total_price']),
      currency: json['currency'] as String? ?? '',
      deliveryAddress: json['delivery_address'] as String? ?? '',
      note: json['note'] as String? ?? '',
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}

class OrderItemModel {
  final int id;
  final int productId;
  final int variantId;
  final int variantSizeId;
  final String productName;
  final int quantity;
  final num unitPrice;
  final num totalPrice;

  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.variantId,
    required this.variantSizeId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int? ?? 0,
      productId: json['product_id'] as int? ?? 0,
      variantId: json['variant_id'] as int? ?? 0,
      variantSizeId: json['variant_size_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      unitPrice: _parseNum(json['unit_price']),
      totalPrice: _parseNum(json['total_price']),
    );
  }
}
