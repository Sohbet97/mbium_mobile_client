import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductsResponse {
  final List<ProductModel> products;
  final int count;

  const ProductsResponse({
    required this.products,
    required this.count,
  });

  // hasMore вычисляется снаружи — bloc знает page и limit
  bool hasMore(int page, int limit) => page * limit < count;

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return ProductsResponse(
      products: data
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int? ?? data.length,
    );
  }
}
