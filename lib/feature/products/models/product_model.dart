import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';

class ProductModel {
  final int id;
  final int shopId;
  final int categoryId;
  final String name;
  final String nameRu;
  final String nameEng;
  final String description;
  final double price;
  final String currency;
  final double? compareAtPrice;
  final String sku;
  final String? barcode;
  final double? weight;
  final int stock;
  final List<String> tags;
  final String? handle;
  final String? seoTitle;
  final String? seoDescription;
  final double rating;
  final int reviewCount;
  final int status;
  final double? costPrice;
  final bool isPhysical;
  final bool trackInventory;
  final bool sellWhenOutOfStock;
  final bool isActive;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final ProductCategory? category;
  final ProductShop? shop;
  final List<ProductMedia> productMedia;

  ProductModel({
    required this.id,
    required this.shopId,
    required this.categoryId,
    required this.name,
    required this.nameRu,
    required this.nameEng,
    required this.description,
    required this.price,
    required this.currency,
    this.compareAtPrice,
    required this.sku,
    this.barcode,
    this.weight,
    required this.stock,
    required this.tags,
    this.handle,
    this.seoTitle,
    this.seoDescription,
    required this.rating,
    required this.reviewCount,
    required this.status,
    this.costPrice,
    required this.isPhysical,
    required this.trackInventory,
    required this.sellWhenOutOfStock,
    required this.isActive,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.category,
    this.shop,
    required this.productMedia,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    double? parseOptionalDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    return ProductModel(
      id: json['id'] as int,
      // Partial payloads (e.g. the nested `product` in GET /favorites) omit
      // these — default to 0 rather than crashing.
      shopId: json['shop_id'] as int? ?? 0,
      categoryId: json['category_id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nameRu: json['name_ru'] as String? ?? '',
      nameEng: json['name_eng'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: parseDouble(json['price']),
      currency: json['currency'] as String? ?? 'TMT',
      compareAtPrice: parseOptionalDouble(json['compare_at_price']),
      sku: json['sku'] as String? ?? '',
      barcode: json['barcode'] as String?,
      weight: parseOptionalDouble(json['weight']),
      stock: json['stock'] as int? ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      handle: json['handle'] as String?,
      seoTitle: json['seo_title'] as String?,
      seoDescription: json['seo_description'] as String?,
      rating: parseDouble(json['rating']),
      reviewCount: json['review_count'] as int? ?? 0,
      status: json['status'] as int? ?? 0,
      costPrice: parseOptionalDouble(json['cost_price']),
      isPhysical: json['is_physical'] as bool? ?? true,
      trackInventory: json['track_inventory'] as bool? ?? true,
      sellWhenOutOfStock: json['sell_when_out_of_stock'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      category: json['category'] != null
          ? ProductCategory.fromJson(json['category'])
          : null,
      shop: json['shop'] != null ? ProductShop.fromJson(json['shop']) : null,
      productMedia: json['productMedia'] != null
          ? (json['productMedia'] as List)
              .map((e) => ProductMedia.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'category_id': categoryId,
      'name': name,
      'name_ru': nameRu,
      'name_eng': nameEng,
      'description': description,
      'price': price.toStringAsFixed(2),
      'currency': currency,
      'compare_at_price': compareAtPrice,
      'sku': sku,
      'barcode': barcode,
      'weight': weight,
      'stock': stock,
      'tags': tags,
      'handle': handle,
      'seo_title': seoTitle,
      'seo_description': seoDescription,
      'rating': rating.toStringAsFixed(2),
      'review_count': reviewCount,
      'status': status,
      'cost_price': costPrice,
      'is_physical': isPhysical,
      'track_inventory': trackInventory,
      'sell_when_out_of_stock': sellWhenOutOfStock,
      'is_active': isActive,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'category': category?.toJson(),
      'shop': shop?.toJson(),
      'productMedia': productMedia.map((m) => {
        'id': m.id,
        'product_id': m.productId,
        'media_id': m.mediaId,
        'role': m.role,
        'sort_order': m.sortOrder,
        'media': {'id': m.media.id, 'url': m.media.url, 'thumbnail_url': m.media.thumbnailUrl},
      }).toList(),
    };
  }

  /// URL главного фото (role=primary), иначе первое из списка
  String? get primaryImageUrl {
    final primary = productMedia
        .where((m) => m.role == 'primary')
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (primary.isNotEmpty) return primary.first.url;
    if (productMedia.isNotEmpty) return productMedia.first.url;
    return null;
  }

  String? get primaryThumbnailUrl {
    final primary = productMedia
        .where((m) => m.role == 'primary')
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    if (primary.isNotEmpty) return primary.first.thumbnailUrl;
    if (productMedia.isNotEmpty) return productMedia.first.thumbnailUrl;
    return null;
  }
}

class ProductCategory {
  final int id;
  final String name;

  ProductCategory({required this.id, required this.name});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class ProductShop {
  final int id;
  final String name;

  ProductShop({required this.id, required this.name});

  factory ProductShop.fromJson(Map<String, dynamic> json) {
    return ProductShop(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
