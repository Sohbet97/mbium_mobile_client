import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/feature/cart_page/models/cart_model.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';

/// Raw cart line as returned by GET /buyer/cart — no product data, just ids.
/// variantId/variantSizeId are 0 for a plain product line.
class CartItemRef {
  final int productId;
  final int variantId;
  final int variantSizeId;
  final int quantity;

  const CartItemRef({
    required this.productId,
    required this.variantId,
    required this.variantSizeId,
    required this.quantity,
  });

  factory CartItemRef.fromJson(Map<String, dynamic> json) {
    return CartItemRef(
      productId: json['product_id'] as int,
      variantId: json['variant_id'] as int? ?? 0,
      variantSizeId: json['variant_size_id'] as int? ?? 0,
      quantity: json['quantity'] as int? ?? 0,
    );
  }
}

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

/// Thrown for a failed cart API call. [serverMessage] is the backend's own
/// `message` field (e.g. "Ýeterlik stok ýok (bar: 0)") when the response
/// body had one — callers should prefer showing that to the user over a
/// generic fallback.
class CartApiException implements Exception {
  final String? serverMessage;
  const CartApiException([this.serverMessage]);

  @override
  String toString() => serverMessage ?? 'CartApiException';
}

String? _serverMessage(DioException e) {
  final data = e.response?.data;
  if (data is Map && data['message'] is String) {
    final message = data['message'] as String;
    if (message.isNotEmpty) return message;
  }
  return null;
}

class CartRepository {
  final Dio dio;
  final ProductRepository productRepository;

  CartRepository({required this.dio, required this.productRepository});

  // GET /buyer/cart returns only product_id/variant_id/variant_size_id/
  // quantity, so each ref is hydrated with a GET /catalog/products/{id} call
  // to get name/price/media for display — the matching variant/size (if any)
  // is resolved from that detail response to apply variant-level price/media
  // overrides.
  Future<List<CartModel>> getCart({CancelToken? cancelToken}) async {
    final refs = await _getCartRefs(cancelToken: cancelToken);
    final items = await Future.wait(
      refs.map((ref) async {
        final detail = await productRepository.getProductDetail(
          ref.productId,
          cancelToken: cancelToken,
        );
        final variant = ref.variantId != 0
            ? _firstWhereOrNull(detail.variants, (v) => v.id == ref.variantId)
            : null;
        final size = variant != null && ref.variantSizeId != 0
            ? _firstWhereOrNull(variant.sizes, (s) => s.id == ref.variantSizeId)
            : null;

        return CartModel(
          product: detail.toProductModel(variant: variant, size: size),
          quantity: ref.quantity,
          addedAt: DateTime.now(),
          variantId: variant?.id,
          variantSizeId: size?.id,
          variantLabel: _variantLabel(variant, size),
        );
      }),
    );
    return items;
  }

  String? _variantLabel(ProductVariant? variant, ProductVariantSize? size) {
    if (variant == null) return null;
    final parts = [variant.name, size?.size?.name].whereType<String>().where(
      (s) => s.isNotEmpty,
    );
    return parts.isEmpty ? null : parts.join(' / ');
  }

  Future<List<CartItemRef>> _getCartRefs({CancelToken? cancelToken}) async {
    try {
      final response = await dio.get('/cart', cancelToken: cancelToken);
      if (response.statusCode != 200) {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as List? ?? [];
      return data
          .map((e) => CartItemRef.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw CartApiException(_serverMessage(e));
    }
  }

  // Upsert semantics: quantity is absolute, not a delta. variantId/
  // variantSizeId are omitted from the body entirely for a plain product
  // (no variant picked), and both included together for a variant+size line.
  Future<void> upsertItem({
    required int productId,
    required int quantity,
    int? variantId,
    int? variantSizeId,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.put(
        '/cart',
        data: {
          'product_id': productId,
          'quantity': quantity,
          'variant_id': ?variantId,
          'variant_size_id': ?variantSizeId,
        },
        cancelToken: cancelToken,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update cart item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw CartApiException(_serverMessage(e));
    }
  }

  // NOTE: the API only documents this as `/cart/{itemId}` with no field in
  // the GET response to say what itemId is. We're sending product_id here.
  // That is known to be ambiguous for products with multiple variant lines
  // in the cart (removing one variant may remove/target the wrong line) —
  // confirm the real key with backend before relying on this for variant
  // products.
  Future<void> removeItem(int productId, {CancelToken? cancelToken}) async {
    try {
      final response = await dio.delete(
        '/cart/$productId',
        cancelToken: cancelToken,
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove cart item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw CartApiException(_serverMessage(e));
    }
  }

  Future<void> clearCart({CancelToken? cancelToken}) async {
    try {
      final response = await dio.delete('/cart', cancelToken: cancelToken);
      if (response.statusCode != 200) {
        throw Exception('Failed to clear cart: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) rethrow;
      throw CartApiException(_serverMessage(e));
    }
  }
}
