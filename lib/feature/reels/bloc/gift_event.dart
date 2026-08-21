part of 'gift_bloc.dart';

sealed class GiftEvent extends Equatable {
  const GiftEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the gift catalog once; a repeat call is a no-op while it's already
/// loaded or in flight (the catalog rarely changes within a session).
final class LoadGiftTypes extends GiftEvent {
  const LoadGiftTypes();
}

final class LoadReelGifts extends GiftEvent {
  final int reelId;

  const LoadReelGifts(this.reelId);

  @override
  List<Object?> get props => [reelId];
}

final class SendGift extends GiftEvent {
  final int reelId;
  final int giftTypeId;
  final String? message;

  const SendGift({
    required this.reelId,
    required this.giftTypeId,
    this.message,
  });

  @override
  List<Object?> get props => [reelId, giftTypeId, message];
}
