part of 'reels_bloc.dart';

sealed class ReelsState extends Equatable {
  const ReelsState();

  @override
  List<Object?> get props => [];
}

final class ReelsInitial extends ReelsState {}

final class ReelsLoading extends ReelsState {}

final class ReelsLoaded extends ReelsState {
  final List<ReelsModel> reels;
  final bool hasMore;
  final bool isLoadingMore;
  final ReelsFilterModel filter;

  const ReelsLoaded({
    required this.reels,
    required this.hasMore,
    required this.filter,
    this.isLoadingMore = false,
  });

  ReelsLoaded copyWith({
    List<ReelsModel>? reels,
    bool? hasMore,
    bool? isLoadingMore,
    ReelsFilterModel? filter,
  }) {
    return ReelsLoaded(
      reels: reels ?? this.reels,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [reels, hasMore, isLoadingMore, filter];
}

final class ReelsError extends ReelsState {
  final String message;
  final ReelsFilterModel? filter;

  const ReelsError({required this.message, this.filter});

  @override
  List<Object?> get props => [message, filter];
}
