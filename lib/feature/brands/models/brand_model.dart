class BrandModel {
  final int id;
  final String name;
  final String nameRu;
  final String nameEn;
  final String slug;
  final int? parentId;
  final String? logoUrl;
  final String? description;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;

  const BrandModel({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameEn,
    required this.slug,
    this.parentId,
    this.logoUrl,
    this.description,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameRu: json['name_ru'] as String? ?? '',
      nameEn: json['name_en'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      parentId: json['parent_id'] as int?,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ru': nameRu,
      'name_en': nameEn,
      'slug': slug,
      'parent_id': parentId,
      'logo_url': logoUrl,
      'description': description,
      'is_active': isActive,
      'sort_order': sortOrder,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
