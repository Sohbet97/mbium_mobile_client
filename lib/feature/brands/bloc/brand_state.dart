part of 'brand_bloc.dart';

sealed class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object?> get props => [];
}

final class BrandInitial extends BrandState {}

final class BrandLoading extends BrandState {}

final class BrandLoaded extends BrandState {
  final List<BrandModel> brands;
  final int count;
  final BrandFilter filter;
  final bool isLoadingMore;
  final bool hasMore;

  const BrandLoaded({
    required this.brands,
    required this.count,
    required this.filter,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  BrandLoaded copyWith({
    List<BrandModel>? brands,
    int? count,
    BrandFilter? filter,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return BrandLoaded(
      brands: brands ?? this.brands,
      count: count ?? this.count,
      filter: filter ?? this.filter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [brands, count, filter, isLoadingMore, hasMore];
}

final class BrandError extends BrandState {
  final String errorMessage;

  const BrandError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
