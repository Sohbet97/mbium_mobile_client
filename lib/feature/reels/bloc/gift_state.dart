part of 'gift_bloc.dart';

/// Sentinel used by [GiftLoaded.copyWith] so nullable fields (the various
/// error messages, the last-sent gift) can be explicitly reset to null
/// instead of always falling back to "keep the old value".
const Object _unset = Object();

sealed class GiftState extends Equatable {
  const GiftState();

  @override
  List<Object?> get props => [];
}

final class GiftInitial extends GiftState {}

final class GiftLoaded extends GiftState {
  final List<GiftTypeModel> giftTypes;
  final bool giftTypesLoading;
  final String? giftTypesError;

  /// Gift history per reel id, populated on demand via [LoadReelGifts].
  final Map<int, List<GiftModel>> reelGifts;
  final Set<int> loadingReelGiftIds;

  final bool isSending;
  final String? sendError;
  final GiftModel? lastSentGift;

  const GiftLoaded({
    this.giftTypes = const [],
    this.giftTypesLoading = false,
    this.giftTypesError,
    this.reelGifts = const {},
    this.loadingReelGiftIds = const {},
    this.isSending = false,
    this.sendError,
    this.lastSentGift,
  });

  GiftLoaded copyWith({
    List<GiftTypeModel>? giftTypes,
    bool? giftTypesLoading,
    Object? giftTypesError = _unset,
    Map<int, List<GiftModel>>? reelGifts,
    Set<int>? loadingReelGiftIds,
    bool? isSending,
    Object? sendError = _unset,
    Object? lastSentGift = _unset,
  }) {
    return GiftLoaded(
      giftTypes: giftTypes ?? this.giftTypes,
      giftTypesLoading: giftTypesLoading ?? this.giftTypesLoading,
      giftTypesError: identical(giftTypesError, _unset)
          ? this.giftTypesError
          : giftTypesError as String?,
      reelGifts: reelGifts ?? this.reelGifts,
      loadingReelGiftIds: loadingReelGiftIds ?? this.loadingReelGiftIds,
      isSending: isSending ?? this.isSending,
      sendError: identical(sendError, _unset)
          ? this.sendError
          : sendError as String?,
      lastSentGift: identical(lastSentGift, _unset)
          ? this.lastSentGift
          : lastSentGift as GiftModel?,
    );
  }

  @override
  List<Object?> get props => [
    giftTypes,
    giftTypesLoading,
    giftTypesError,
    reelGifts,
    loadingReelGiftIds,
    isSending,
    sendError,
    lastSentGift,
  ];
}
