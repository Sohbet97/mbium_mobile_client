class BrandFilter {
  final String? search;
  final int limit;
  final int skip;

  const BrandFilter({this.search, this.limit = 20, this.skip = 0});

  BrandFilter copyWith({
    String? search,
    int? limit,
    int? skip,
    bool clearSearch = false,
  }) {
    return BrandFilter(
      search: clearSearch ? null : (search ?? this.search),
      limit: limit ?? this.limit,
      skip: skip ?? this.skip,
    );
  }

  BrandFilter nextPage() => copyWith(skip: skip + limit);

  BrandFilter resetPage() => copyWith(skip: 0);

  Map<String, dynamic> toQueryParameters() {
    return {
      'limit': limit,
      'skip': skip,
      if (search != null && search!.isNotEmpty) 'search': search,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandFilter &&
          other.search == search &&
          other.limit == limit &&
          other.skip == skip;

  @override
  int get hashCode => Object.hash(search, limit, skip);
}
