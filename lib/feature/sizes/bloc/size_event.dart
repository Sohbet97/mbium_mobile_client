part of 'size_bloc.dart';

sealed class SizeEvent extends Equatable {
  const SizeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadSizesEvent extends SizeEvent {
  final SizeFilter filter;

  const LoadSizesEvent({this.filter = const SizeFilter()});

  @override
  List<Object?> get props => [filter];
}

final class SearchSizesEvent extends SizeEvent {
  final String search;

  const SearchSizesEvent(this.search);

  @override
  List<Object?> get props => [search];
}

final class LoadMoreSizesEvent extends SizeEvent {
  const LoadMoreSizesEvent();
}
