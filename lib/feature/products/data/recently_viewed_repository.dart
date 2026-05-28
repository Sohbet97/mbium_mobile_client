import 'dart:convert';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class RecentlyViewedRepository {
  static const _key = 'recently_viewed_products';
  static const _maxCount = 20;

  final AppPreferences preferences;

  RecentlyViewedRepository({required this.preferences});

  List<ProductModel> load() {
    final raw = preferences.getStringList(_key) ?? [];
    return raw
        .map((e) {
          try {
            return ProductModel.fromJson(jsonDecode(e) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<ProductModel>()
        .toList();
  }

  Future<List<ProductModel>> add(ProductModel product) async {
    final current = load();

    current.removeWhere((p) => p.id == product.id);

    current.insert(0, product);

    final trimmed = current.take(_maxCount).toList();

    await preferences.setStringList(
      _key,
      trimmed.map((p) => jsonEncode(p.toJson())).toList(),
    );

    return trimmed;
  }

  Future<void> clear() async {
    await preferences.setStringList(_key, []);
  }
}
