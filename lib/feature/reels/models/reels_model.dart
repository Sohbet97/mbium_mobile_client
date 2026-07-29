import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

class ReelsModel {
  final int id;
  final int shopId;
  final String caption;
  final int viewCount;
  final bool isActive;
  final int? productId;
  final DateTime? createdAt;
  final ReelVideo video;
  final ReelThumbnail? thumbnail;
  final ReelShop shop;
  final ReelProduct? product;

  const ReelsModel({
    required this.id,
    required this.shopId,
    required this.caption,
    required this.viewCount,
    required this.isActive,
    this.productId,
    this.createdAt,
    required this.video,
    this.thumbnail,
    required this.shop,
    this.product,
  });

  factory ReelsModel.fromJson(Map<String, dynamic> json) {
    return ReelsModel(
      id: json['id'] as int? ?? 0,
      shopId: json['shop_id'] as int? ?? 0,
      caption: json['caption'] as String? ?? '',
      viewCount: json['view_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      productId: json['product_id'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      video: ReelVideo.fromJson(json['video'] as Map<String, dynamic>? ?? {}),
      thumbnail: json['thumbnail'] != null
          ? ReelThumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>)
          : null,
      shop: ReelShop.fromJson(json['shop'] as Map<String, dynamic>? ?? {}),
      product: json['product'] != null
          ? ReelProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'shop_id': shopId,
      'caption': caption,
      'view_count': viewCount,
      'is_active': isActive,
      'product_id': productId,
      'createdAt': createdAt?.toIso8601String(),
      'video': video.toJson(),
      'thumbnail': thumbnail?.toJson(),
      'shop': shop.toJson(),
      'product': product?.toJson(),
    };
  }

  factory ReelsModel.empty() {
    return const ReelsModel(
      id: 0,
      shopId: 0,
      caption: '',
      viewCount: 0,
      isActive: true,
      video: ReelVideo(id: '', url: '', mimeType: '', size: 0),
      shop: ReelShop(id: 0, name: ''),
    );
  }

  @override
  String toString() => 'ReelsModel(id: $id, videoUrl: ${video.url})';
}

class ReelVideo {
  final String id;
  final String url;
  final String mimeType;
  final int size;

  const ReelVideo({
    required this.id,
    required this.url,
    required this.mimeType,
    required this.size,
  });

  factory ReelVideo.fromJson(Map<String, dynamic> json) {
    return ReelVideo(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      mimeType: json['mime_type'] as String? ?? '',
      size: json['size'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'mime_type': mimeType, 'size': size};
  }
}

class ReelThumbnail {
  final String id;
  final String url;
  final String thumbnailUrl;

  const ReelThumbnail({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
  });

  factory ReelThumbnail.fromJson(Map<String, dynamic> json) {
    return ReelThumbnail(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'thumbnail_url': thumbnailUrl};
  }
}

class ReelShop {
  final int id;
  final String name;
  final String? logo;

  const ReelShop({required this.id, required this.name, this.logo});

  factory ReelShop.fromJson(Map<String, dynamic> json) {
    return ReelShop(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'logo': logo};
  }

  /// Only the fields the reel endpoint gives us — [ShopDetailScreen] fetches
  /// the rest by id.
  ShopModel toShopModel() => ShopModel(id: id, name: name, logo: logo);
}

class ReelProduct {
  final int id;
  final String name;
  final double price;
  final String currency;

  const ReelProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
  });

  factory ReelProduct.fromJson(Map<String, dynamic> json) {
    return ReelProduct(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'TMT',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'currency': currency};
  }

  /// [ProductModel.fromJson] already defaults every field it doesn't get —
  /// [ProductDetailScreen] re-fetches the full product by id anyway, so this
  /// partial payload only needs to carry enough for the id lookup + an
  /// optimistic name/price flash before that finishes.
  ProductModel toProductModel() => ProductModel.fromJson(toJson());
}
