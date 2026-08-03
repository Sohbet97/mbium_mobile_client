import 'package:equatable/equatable.dart';

class ShopFilterModel extends Equatable {
  final int page;
  final int limit;
  final String? text;
  final int? typeId;
  final int? categoryId;

  const ShopFilterModel({
    this.page = 1,
    this.limit = 20,
    this.text,
    this.typeId,
    this.categoryId,
  });

  ShopFilterModel copyWith({
    int? page,
    int? limit,
    String? text,
    int? typeId,
    int? categoryId,
    bool clearText = false,
    bool clearTypeId = false,
    bool clearCategoryId = false,
  }) {
    return ShopFilterModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      text: clearText ? null : (text ?? this.text),
      typeId: clearTypeId ? null : (typeId ?? this.typeId),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
    );
  }

  ShopFilterModel resetPage() => copyWith(page: 1);

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (text != null && text!.isNotEmpty) 'text': text,
      if (typeId != null) 'type_id': typeId,
      if (categoryId != null) 'category_id': categoryId,
    };
  }

  @override
  List<Object?> get props => [page, limit, text, typeId, categoryId];
}
