class CollectionModel {
  final int id;
  final String name;
  final String nameRu;
  final String nameEng;
  final String? description;
  final String? imageUrl;
  final String handle;
  final String? seoTitle;
  final String? seoDescription;
  final int sortOrder;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final int productCount;

  const CollectionModel({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameEng,
    this.description,
    this.imageUrl,
    required this.handle,
    this.seoTitle,
    this.seoDescription,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.productCount,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameRu: json['name_ru'] as String? ?? '',
      nameEng: json['name_eng'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      handle: json['handle'] as String? ?? '',
      seoTitle: json['seo_title'] as String?,
      seoDescription: json['seo_description'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      productCount: int.tryParse(json['product_count']?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ru': nameRu,
      'name_eng': nameEng,
      'description': description,
      'image_url': imageUrl,
      'handle': handle,
      'seo_title': seoTitle,
      'seo_description': seoDescription,
      'sort_order': sortOrder,
      'is_active': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'product_count': productCount.toString(),
    };
  }
}
