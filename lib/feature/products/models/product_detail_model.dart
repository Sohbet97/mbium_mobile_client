import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductDetailModel {
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
  final int soldCount;
  final int status;
  final double? costPrice;
  final bool isPhysical;
  final bool trackInventory;
  final bool sellWhenOutOfStock;
  final bool isActive;
  final int? brandId;
  final int? supplierId;
  final bool isPublished;
  final DateTime? scheduledAt;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final ProductDetailCategory? category;
  final ProductDetailShop? shop;
  final List<ProductVariant> variants;
  final List<ProductMedia> productMedia;

  const ProductDetailModel({
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
    required this.soldCount,
    required this.status,
    this.costPrice,
    required this.isPhysical,
    required this.trackInventory,
    required this.sellWhenOutOfStock,
    required this.isActive,
    this.brandId,
    this.supplierId,
    required this.isPublished,
    this.scheduledAt,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.category,
    this.shop,
    required this.variants,
    required this.productMedia,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['model'] as Map<String, dynamic>? ?? json;

    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    double? parseOptionalDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return ProductDetailModel(
      id: data['id'] as int,
      shopId: data['shop_id'] as int,
      categoryId: data['category_id'] as int,
      name: data['name'] as String? ?? '',
      nameRu: data['name_ru'] as String? ?? '',
      nameEng: data['name_eng'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: parseDouble(data['price']),
      currency: data['currency'] as String? ?? 'TMT',
      compareAtPrice: parseOptionalDouble(data['compare_at_price']),
      sku: data['sku'] as String? ?? '',
      barcode: data['barcode'] as String?,
      weight: parseOptionalDouble(data['weight']),
      stock: data['stock'] as int? ?? 0,
      tags: data['tags'] != null ? List<String>.from(data['tags']) : [],
      handle: data['handle'] as String?,
      seoTitle: data['seo_title'] as String?,
      seoDescription: data['seo_description'] as String?,
      rating: parseDouble(data['rating']),
      reviewCount: data['review_count'] as int? ?? 0,
      soldCount: data['sold_count'] as int? ?? 0,
      status: data['status'] as int? ?? 0,
      costPrice: parseOptionalDouble(data['cost_price']),
      isPhysical: data['is_physical'] as bool? ?? true,
      trackInventory: data['track_inventory'] as bool? ?? true,
      sellWhenOutOfStock: data['sell_when_out_of_stock'] as bool? ?? false,
      isActive: data['is_active'] as bool? ?? true,
      brandId: data['brand_id'] as int?,
      supplierId: data['supplier_id'] as int?,
      isPublished: data['is_published'] as bool? ?? false,
      scheduledAt: data['scheduled_at'] != null
          ? DateTime.parse(data['scheduled_at'])
          : null,
      createdBy: data['createdBy'] as String?,
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.parse(data['updatedAt'])
          : DateTime.now(),
      deletedAt: data['deletedAt'] != null
          ? DateTime.parse(data['deletedAt'])
          : null,
      category: data['category'] != null
          ? ProductDetailCategory.fromJson(data['category'])
          : null,
      shop: data['shop'] != null
          ? ProductDetailShop.fromJson(data['shop'])
          : null,
      variants: data['variants'] != null
          ? (data['variants'] as List)
              .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      productMedia: data['productMedia'] != null
          ? (data['productMedia'] as List)
              .map((e) => ProductMedia.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  List<ProductMedia> get primaryMedia =>
      productMedia.where((m) => m.role == 'primary').toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<ProductMedia> get galleryMedia =>
      productMedia.where((m) => m.role == 'gallery').toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  List<ProductMedia> get spinMedia =>
      productMedia.where((m) => m.role == 'spin').toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

  /// Primary first, then gallery, sorted by sort_order
  List<ProductMedia> get displayMedia {
    final result = [...primaryMedia, ...galleryMedia];
    if (result.isEmpty) return productMedia;
    return result;
  }

  /// Maps to the lightweight [ProductModel] shape used by cart/favorites/grid
  /// widgets. When [variant]/[size] are given, price/compareAtPrice/media are
  /// overridden with the variant's own values where present, falling back to
  /// the base product's otherwise.
  ProductModel toProductModel({ProductVariant? variant, ProductVariantSize? size}) {
    final effectivePrice = size?.price ?? variant?.price ?? price;
    final effectiveCompareAtPrice =
        size?.compareAtPrice ?? variant?.compareAtPrice ?? compareAtPrice;
    final effectiveMedia =
        variant != null && variant.media.isNotEmpty ? variant.media : productMedia;

    return ProductModel(
      id: id,
      shopId: shopId,
      categoryId: categoryId,
      name: name,
      nameRu: nameRu,
      nameEng: nameEng,
      description: description,
      price: effectivePrice,
      currency: currency,
      compareAtPrice: effectiveCompareAtPrice,
      sku: size?.sku ?? variant?.sku ?? sku,
      barcode: size?.barcode ?? variant?.barcode ?? barcode,
      weight: weight,
      stock: size?.stock ?? variant?.stock ?? stock,
      tags: tags,
      handle: handle,
      seoTitle: seoTitle,
      seoDescription: seoDescription,
      rating: rating,
      reviewCount: reviewCount,
      status: status,
      costPrice: costPrice,
      isPhysical: isPhysical,
      trackInventory: trackInventory,
      sellWhenOutOfStock: sellWhenOutOfStock,
      isActive: isActive,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      category: category != null
          ? ProductCategory(id: category!.id, name: category!.name)
          : null,
      shop: shop != null ? ProductShop(id: shop!.id, name: shop!.name) : null,
      productMedia: effectiveMedia,
    );
  }
}

class ProductDetailCategory {
  final int id;
  final String name;
  final String? slug;

  const ProductDetailCategory({
    required this.id,
    required this.name,
    this.slug,
  });

  factory ProductDetailCategory.fromJson(Map<String, dynamic> json) {
    return ProductDetailCategory(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
    );
  }
}

class ProductDetailShop {
  final int id;
  final String name;
  final String? logo;

  const ProductDetailShop({
    required this.id,
    required this.name,
    this.logo,
  });

  factory ProductDetailShop.fromJson(Map<String, dynamic> json) {
    return ProductDetailShop(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
    );
  }
}

class ProductVariant {
  final int id;
  final int productId;
  final String name;
  final String? sku;
  final String? barcode;
  final double? price;
  final double? compareAtPrice;
  final int stock;
  final Map<String, dynamic> attributes;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<ProductVariantSize> sizes;
  final List<ProductMedia> media;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.name,
    this.sku,
    this.barcode,
    this.price,
    this.compareAtPrice,
    required this.stock,
    required this.attributes,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.sizes = const [],
    this.media = const [],
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    double? parseOptionalDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return ProductVariant(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      price: parseOptionalDouble(json['price']),
      compareAtPrice: parseOptionalDouble(json['compare_at_price']),
      stock: json['stock'] as int? ?? 0,
      attributes: json['attributes'] as Map<String, dynamic>? ?? {},
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      sizes: json['sizes'] != null
          ? (json['sizes'] as List)
              .map((e) => ProductVariantSize.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      media: json['media'] != null
          ? (json['media'] as List)
              .map((e) => ProductMedia.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  String? get primaryImageUrl {
    if (media.isEmpty) return null;
    final primary = media.where((m) => m.role == 'primary').toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return primary.isNotEmpty ? primary.first.url : media.first.url;
  }

  List<ProductVariantSize> get availableSizes =>
      sizes.where((s) => s.isActive && s.stock > 0).toList();
}

/// A specific size of a [ProductVariant] — its `id` is the `variant_size_id`
/// used when adding this exact variant+size combo to the cart.
class ProductVariantSize {
  final int id;
  final int variantId;
  final int sizeId;
  final String? sku;
  final String? barcode;
  final double? price;
  final double? compareAtPrice;
  final int stock;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final ProductSizeInfo? size;

  const ProductVariantSize({
    required this.id,
    required this.variantId,
    required this.sizeId,
    this.sku,
    this.barcode,
    this.price,
    this.compareAtPrice,
    required this.stock,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.size,
  });

  factory ProductVariantSize.fromJson(Map<String, dynamic> json) {
    double? parseOptionalDouble(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return ProductVariantSize(
      id: json['id'] as int,
      variantId: json['variant_id'] as int,
      sizeId: json['size_id'] as int,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      price: parseOptionalDouble(json['price']),
      compareAtPrice: parseOptionalDouble(json['compare_at_price']),
      stock: json['stock'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
      size: json['size'] != null
          ? ProductSizeInfo.fromJson(json['size'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ProductSizeInfo {
  final int id;
  final String name;
  final String nameRu;
  final String nameEng;
  final String? slug;

  const ProductSizeInfo({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameEng,
    this.slug,
  });

  factory ProductSizeInfo.fromJson(Map<String, dynamic> json) {
    return ProductSizeInfo(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameRu: json['name_ru'] as String? ?? '',
      nameEng: json['name_eng'] as String? ?? '',
      slug: json['slug'] as String?,
    );
  }
}

class ProductMedia {
  final int id;
  final int productId;
  final String mediaId;
  final int? variantId;
  final String role;
  final int sortOrder;
  final MediaModel media;

  const ProductMedia({
    required this.id,
    required this.productId,
    required this.mediaId,
    this.variantId,
    required this.role,
    required this.sortOrder,
    required this.media,
  });

  factory ProductMedia.fromJson(Map<String, dynamic> json) {
    return ProductMedia(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      mediaId: json['media_id'] as String,
      variantId: json['variant_id'] as int?,
      role: json['role'] as String? ?? 'gallery',
      sortOrder: json['sort_order'] as int? ?? 0,
      media: MediaModel.fromJson(json['media'] as Map<String, dynamic>),
    );
  }

  String get url => media.url;
  String get thumbnailUrl => media.thumbnailUrl;
}

class MediaModel {
  final String id;
  final String filename;
  final String originalName;
  final String mimeType;
  final String size;
  final String type;
  final String url;
  final String thumbnailUrl;
  final String? altText;
  final int? width;
  final int? height;
  final String? duration;
  final String uploadedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const MediaModel({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.mimeType,
    required this.size,
    required this.type,
    required this.url,
    required this.thumbnailUrl,
    this.altText,
    this.width,
    this.height,
    this.duration,
    required this.uploadedBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'] as String,
      filename: json['filename'] as String? ?? '',
      originalName: json['original_name'] as String? ?? '',
      mimeType: json['mime_type'] as String? ?? '',
      size: json['size'] as String? ?? '0',
      type: json['type'] as String? ?? 'image',
      url: json['url'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      altText: json['alt_text'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      duration: json['duration'] as String?,
      uploadedBy: json['uploaded_by'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }
}
