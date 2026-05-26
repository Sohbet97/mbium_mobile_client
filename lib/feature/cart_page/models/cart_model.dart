import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class CartModel {
  final ProductModel product;
  final int quantity;
  final DateTime addedAt;

  CartModel({
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  CartModel copyWith({
    ProductModel? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
