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

final class LikeReel extends ReelsEvent {
  final int reelId;

  const LikeReel(this.reelId);

  @override
  List<Object?> get props => [reelId];
}
