class CategoryModel {
  final int id;
  final int? parentId;
  final String name;
  final String nameRu;
  final String nameEng;
  final String slug;
  final String? icon;
  final String? image;
  final int order;
  final String? seoTitle;
  final String? seoDescription;
  final int status;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  List<CategoryModel> children;

  CategoryModel({
    required this.id,
    this.parentId,
    required this.name,
    required this.nameRu,
    required this.nameEng,
    required this.slug,
    this.icon,
    this.image,
    required this.order,
    this.seoTitle,
    this.seoDescription,
    required this.status,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    List<CategoryModel>? children,
  }) : children = children ?? [];

  // JSON-dan model döretmek üçin factory constructor
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      parentId: json['parent_id'] as int?,
      name: json['name'] as String? ?? '',
      nameRu: json['name_ru'] as String? ?? '',
      nameEng: json['name_eng'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      order: json['order'] as int? ?? 0,
      seoTitle: json['seo_title'] as String?,
      seoDescription: json['seo_description'] as String?,
      status: json['status'] as int? ?? 1,
      createdBy: json['createdBy'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      children: json['children'] != null
          ? (json['children'] as List)
                .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  // Modeli JSON formatyna öwürmek üçin
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'name': name,
      'name_ru': nameRu,
      'name_eng': nameEng,
      'slug': slug,
      'icon': icon,
      'image': image,
      'order': order,
      'seo_title': seoTitle,
      'seo_description': seoDescription,
      'status': status,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'children': children.map((e) => e.toJson()).toList(),
    };
  }

  // Ýapyk sanawdan (flat list) parent_id/id baglanyşygy arkaly agaç (tree) gurmak
  static List<CategoryModel> buildTree(List<CategoryModel> flatList) {
    final byId = {for (final category in flatList) category.id: category};
    final roots = <CategoryModel>[];

    for (final category in flatList) {
      category.children = [];
    }

    for (final category in flatList) {
      final parent = byId[category.parentId];
      if (parent != null) {
        parent.children.add(category);
      } else {
        roots.add(category);
      }
    }

    for (final category in flatList) {
      category.children.sort((a, b) => a.order.compareTo(b.order));
    }
    roots.sort((a, b) => a.order.compareTo(b.order));

    return roots;
  }
}
