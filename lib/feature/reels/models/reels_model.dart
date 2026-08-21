import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

class ReelsModel {
  final int id;
  final int shopId;
  final String caption;
  final int viewCount;
  final int likeCount;
  final int giftCount;
  final int giftCoinTotal;
  final bool isActive;
  final int moderationStatus;
  final String? moderationNote;
  final DateTime? moderatedAt;
  final int? moderatedBy;
  final int? productId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final ReelVideo video;
  final ReelThumbnail? thumbnail;
  final ReelShop shop;
  final ReelProduct? product;

  const ReelsModel({
    required this.id,
    required this.shopId,
    required this.caption,
    required this.viewCount,
    this.likeCount = 0,
    this.giftCount = 0,
    this.giftCoinTotal = 0,
    required this.isActive,
    this.moderationStatus = 0,
    this.moderationNote,
    this.moderatedAt,
    this.moderatedBy,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
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
      likeCount: json['like_count'] as int? ?? 0,
      giftCount: json['gift_count'] as int? ?? 0,
      giftCoinTotal: json['gift_coin_total'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      moderationStatus: json['moderation_status'] as int? ?? 0,
      moderationNote: json['moderation_note'] as String?,
      moderatedAt: json['moderated_at'] != null
          ? DateTime.tryParse(json['moderated_at'] as String)
          : null,
      moderatedBy: json['moderated_by'] as int?,
      productId: json['product_id'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      deletedAt: json['deletedAt'] != null
          ? DateTime.tryParse(json['deletedAt'] as String)
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
      'like_count': likeCount,
      'gift_count': giftCount,
      'gift_coin_total': giftCoinTotal,
      'is_active': isActive,
      'moderation_status': moderationStatus,
      'moderation_note': moderationNote,
      'moderated_at': moderatedAt?.toIso8601String(),
      'moderated_by': moderatedBy,
      'product_id': productId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
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
    int parseInt(dynamic value) {
      if (value is num) return value.toInt();
      return int.tryParse(value?.toString() ?? '') ?? 0;
    }

    return ReelVideo(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      mimeType: json['mime_type'] as String? ?? '',
      size: parseInt(json['size']),
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
    double parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0.0;
    }

    return ReelProduct(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      price: parseDouble(json['price']),
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
