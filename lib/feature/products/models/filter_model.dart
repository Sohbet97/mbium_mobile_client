class FilterModel {
  final int page;
  final int limit;
  final String? text;
  final int? categoryId;
  final int? shopId;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  const FilterModel({
    this.page = 1,
    this.limit = 20,
    this.text,
    this.categoryId,
    this.shopId,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  FilterModel copyWith({
    int? page,
    int? limit,
    String? text,
    int? categoryId,
    int? shopId,
    double? minPrice,
    double? maxPrice,
    String? sort,
    bool clearText = false,
    bool clearCategory = false,
    bool clearShop = false,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    bool clearSort = false,
  }) {
    return FilterModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      text: clearText ? null : (text ?? this.text),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      shopId: clearShop ? null : (shopId ?? this.shopId),
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sort: clearSort ? null : (sort ?? this.sort),
    );
  }

  FilterModel resetPage() => copyWith(page: 1);

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (text != null && text!.isNotEmpty) 'text': text,
      if (categoryId != null) 'category_id': categoryId,
      if (shopId != null) 'shop_id': shopId,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      if (sort != null) 'sort': sort,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterModel &&
          other.page == page &&
          other.limit == limit &&
          other.text == text &&
          other.categoryId == categoryId &&
          other.shopId == shopId &&
          other.minPrice == minPrice &&
          other.maxPrice == maxPrice &&
          other.sort == sort;

  @override
  int get hashCode => Object.hash(
    page,
    limit,
    text,
    categoryId,
    shopId,
    minPrice,
    maxPrice,
    sort,
  );
}
