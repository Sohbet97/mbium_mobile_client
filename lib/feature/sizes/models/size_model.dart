class SizeModel {
  final int id;
  final String name;
  final String nameRu;
  final String nameEng;
  final String slug;
  final int? parentId;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final List<SizeModel> children;

  const SizeModel({
    required this.id,
    required this.name,
    required this.nameRu,
    required this.nameEng,
    required this.slug,
    this.parentId,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    this.children = const [],
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      nameRu: json['name_ru'] as String? ?? '',
      nameEng: json['name_eng'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      parentId: json['parent_id'] as int?,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      children: json['children'] != null
          ? (json['children'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => SizeModel.fromJson(e))
                .toList()
          : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ru': nameRu,
      'name_eng': nameEng,
      'slug': slug,
      'parent_id': parentId,
      'is_active': isActive,
      'sort_order': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}
