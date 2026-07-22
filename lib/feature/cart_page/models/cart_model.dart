import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class CartModel {
  final ProductModel product;
  final int quantity;
  final DateTime addedAt;

  /// Null for a plain product line. Set when this line is a specific
  /// variant+size combo — both must be sent together in cart API calls.
  final int? variantId;
  final int? variantSizeId;

  /// Human-readable variant/size, e.g. "Gyzyl / EU 42", for display in the
  /// cart list. Null for plain product lines.
  final String? variantLabel;

  CartModel({
    required this.product,
    required this.quantity,
    required this.addedAt,
    this.variantId,
    this.variantSizeId,
    this.variantLabel,
  });

  /// Whether this line matches the given product+variant+size identity —
  /// used to find/merge the right cart line, since the same product can
  /// have multiple lines for different variants.
  bool matchesLine(int productId, int? variantId, int? variantSizeId) {
    return product.id == productId &&
        this.variantId == variantId &&
        this.variantSizeId == variantSizeId;
  }

  CartModel copyWith({
    ProductModel? product,
    int? quantity,
    DateTime? addedAt,
    int? variantId,
    int? variantSizeId,
    String? variantLabel,
  }) {
    return CartModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
      variantId: variantId ?? this.variantId,
      variantSizeId: variantSizeId ?? this.variantSizeId,
      variantLabel: variantLabel ?? this.variantLabel,
    );
  }
}
