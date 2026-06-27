part of 'brand_bloc.dart';

sealed class BrandEvent extends Equatable {
  const BrandEvent();

  @override
  List<Object?> get props => [];
}

final class LoadBrandsEvent extends BrandEvent {
  final BrandFilter filter;

  const LoadBrandsEvent({this.filter = const BrandFilter()});

  @override
  List<Object?> get props => [filter];
}

final class SearchBrandsEvent extends BrandEvent {
  final String search;

  const SearchBrandsEvent(this.search);

  @override
  List<Object?> get props => [search];
}

final class LoadMoreBrandsEvent extends BrandEvent {
  const LoadMoreBrandsEvent();
}
