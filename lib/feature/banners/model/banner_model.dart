class BannerModel {
  final int? id;
  final int? bannerTypeId;
  final int? shopId;
  final String? title;
  final String? subtitle;
  final String? mediaId;
  final String? imageUrl;
  final String? buttonText;
  final String? buttonUrl;
  final String? linkUrl;
  final int? sortOrder;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BannerTypeModel? bannerType;
  final BannerShopModel? shop;
  final BannerMediaModel? media;

  BannerModel({
    this.id,
    this.bannerTypeId,
    this.shopId,
    this.title,
    this.subtitle,
    this.mediaId,
    this.imageUrl,
    this.buttonText,
    this.buttonUrl,
    this.linkUrl,
    this.sortOrder,
    this.startsAt,
    this.endsAt,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.bannerType,
    this.shop,
    this.media,
  });

  String? get resolvedImageUrl {
    final mediaUrl = media?.url;
    if (mediaUrl != null && mediaUrl.isNotEmpty) return mediaUrl;
    if (imageUrl != null && imageUrl!.isNotEmpty) return imageUrl;
    return null;
  }

  bool get isCurrentlyActive {
    if (isActive != true) return false;
    final now = DateTime.now();
    if (startsAt != null && now.isBefore(startsAt!)) return false;
    if (endsAt != null && now.isAfter(endsAt!)) return false;
    return true;
  }

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as int?,
      bannerTypeId: json['banner_type_id'] as int?,
      shopId: json['shop_id'] as int?,
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      mediaId: json['media_id'] as String?,
      imageUrl: json['image_url'] as String?,
      buttonText: json['button_text'] as String?,
      buttonUrl: json['button_url'] as String?,
      linkUrl: json['link_url'] as String?,
      sortOrder: json['sort_order'] as int?,
      startsAt: json['starts_at'] != null
          ? DateTime.tryParse(json['starts_at'] as String)
          : null,
      endsAt: json['ends_at'] != null
          ? DateTime.tryParse(json['ends_at'] as String)
          : null,
      isActive: json['is_active'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      bannerType: json['banner_type'] != null
          ? BannerTypeModel.fromJson(json['banner_type'] as Map<String, dynamic>)
          : null,
      shop: json['shop'] != null
          ? BannerShopModel.fromJson(json['shop'] as Map<String, dynamic>)
          : null,
      media: json['media'] != null
          ? BannerMediaModel.fromJson(json['media'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'banner_type_id': bannerTypeId,
      'shop_id': shopId,
      'title': title,
      'subtitle': subtitle,
      'media_id': mediaId,
      'image_url': imageUrl,
      'button_text': buttonText,
      'button_url': buttonUrl,
      'link_url': linkUrl,
      'sort_order': sortOrder,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'is_active': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'banner_type': bannerType?.toJson(),
      'shop': shop?.toJson(),
      'media': media?.toJson(),
    };
  }
}

class BannerTypeModel {
  final int? id;
  final String? name;
  final String? nameRu;
  final String? nameEng;
  final String? slug;

  BannerTypeModel({this.id, this.name, this.nameRu, this.nameEng, this.slug});

  factory BannerTypeModel.fromJson(Map<String, dynamic> json) {
    return BannerTypeModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      nameRu: json['name_ru'] as String?,
      nameEng: json['name_eng'] as String?,
      slug: json['slug'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ru': nameRu,
      'name_eng': nameEng,
      'slug': slug,
    };
  }
}

class BannerShopModel {
  final int? id;
  final String? name;

  BannerShopModel({this.id, this.name});

  factory BannerShopModel.fromJson(Map<String, dynamic> json) {
    return BannerShopModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class BannerMediaModel {
  final String? id;
  final String? url;
  final String? thumbnailUrl;
  final String? originalName;
  final String? type;
  final int? width;
  final int? height;

  BannerMediaModel({
    this.id,
    this.url,
    this.thumbnailUrl,
    this.originalName,
    this.type,
    this.width,
    this.height,
  });

  factory BannerMediaModel.fromJson(Map<String, dynamic> json) {
    return BannerMediaModel(
      id: json['id'] as String?,
      url: json['url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      originalName: json['original_name'] as String?,
      type: json['type'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'original_name': originalName,
      'type': type,
      'width': width,
      'height': height,
    };
  }
}
