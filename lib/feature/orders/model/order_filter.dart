class OrderFilter {
  final int page;
  final int limit;
  final int? status;
  final int? shopId;

  const OrderFilter({
    this.page = 1,
    this.limit = 20,
    this.status,
    this.shopId,
  });

  OrderFilter copyWith({
    int? page,
    int? limit,
    int? status,
    int? shopId,
    bool clearStatus = false,
    bool clearShopId = false,
  }) {
    return OrderFilter(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      status: clearStatus ? null : (status ?? this.status),
      shopId: clearShopId ? null : (shopId ?? this.shopId),
    );
  }

  OrderFilter nextPage() => copyWith(page: page + 1);

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
      if (shopId != null) 'shop_id': shopId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderFilter &&
          other.page == page &&
          other.limit == limit &&
          other.status == status &&
          other.shopId == shopId;

  @override
  int get hashCode => Object.hash(page, limit, status, shopId);
}
