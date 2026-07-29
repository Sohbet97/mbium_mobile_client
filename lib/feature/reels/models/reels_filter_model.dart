import 'package:equatable/equatable.dart';

enum ReelsSort {
  newest,
  oldest,
  popular;

  String get value => name;
}

class ReelsFilterModel extends Equatable {
  final int page;
  final int limit;
  final int? shopId;
  final ReelsSort sort;

  const ReelsFilterModel({
    this.page = 1,
    this.limit = 20,
    this.shopId,
    this.sort = ReelsSort.newest,
  });

  ReelsFilterModel copyWith({
    int? page,
    int? limit,
    int? shopId,
    ReelsSort? sort,
    bool clearShopId = false,
  }) {
    return ReelsFilterModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      shopId: clearShopId ? null : (shopId ?? this.shopId),
      sort: sort ?? this.sort,
    );
  }

  ReelsFilterModel resetPage() => copyWith(page: 1);

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (shopId != null) 'shop_id': shopId,
      'sort': sort.value,
    };
  }

  @override
  List<Object?> get props => [page, limit, shopId, sort];
}
