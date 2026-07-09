class SizeFilter {
  final String? search;
  final int limit;
  final int skip;

  const SizeFilter({this.search, this.limit = 20, this.skip = 0});

  SizeFilter copyWith({
    String? search,
    int? limit,
    int? skip,
    bool clearSearch = false,
  }) {
    return SizeFilter(
      search: clearSearch ? null : (search ?? this.search),
      limit: limit ?? this.limit,
      skip: skip ?? this.skip,
    );
  }

  SizeFilter nextPage() => copyWith(skip: skip + limit);

  SizeFilter resetPage() => copyWith(skip: 0);

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
      other is SizeFilter &&
          other.search == search &&
          other.limit == limit &&
          other.skip == skip;

  @override
  int get hashCode => Object.hash(search, limit, skip);
}
