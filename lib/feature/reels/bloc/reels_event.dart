part of 'reels_bloc.dart';

sealed class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadReels extends ReelsEvent {
  final ReelsFilterModel filter;

  const LoadReels(this.filter);

  @override
  List<Object?> get props => [filter];
}

final class LoadMoreReels extends ReelsEvent {
  const LoadMoreReels();
}

final class RefreshReels extends ReelsEvent {
  const RefreshReels();
}
