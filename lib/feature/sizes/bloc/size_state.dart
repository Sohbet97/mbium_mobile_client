part of 'size_bloc.dart';

sealed class SizeState extends Equatable {
  const SizeState();

  @override
  List<Object?> get props => [];
}

final class SizeInitial extends SizeState {}

final class SizeLoading extends SizeState {}

final class SizeLoaded extends SizeState {
  final List<SizeModel> sizes;
  final int count;
  final SizeFilter filter;
  final bool isLoadingMore;
  final bool hasMore;

  const SizeLoaded({
    required this.sizes,
    required this.count,
    required this.filter,
    this.isLoadingMore = false,
    this.hasMore = false,
  });

  SizeLoaded copyWith({
    List<SizeModel>? sizes,
    int? count,
    SizeFilter? filter,
    bool? isLoadingMore,
    bool? hasMore,
  }) {
    return SizeLoaded(
      sizes: sizes ?? this.sizes,
      count: count ?? this.count,
      filter: filter ?? this.filter,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [sizes, count, filter, isLoadingMore, hasMore];
}

final class SizeError extends SizeState {
  final String errorMessage;

  const SizeError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
