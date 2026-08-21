import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/reels/data/gift_repository.dart';
import 'package:mbium_mobile_client/feature/reels/models/gift_model.dart';

part 'gift_event.dart';
part 'gift_state.dart';

class GiftBloc extends Bloc<GiftEvent, GiftState> {
  final GiftRepository repository;

  GiftBloc({required this.repository}) : super(GiftInitial()) {
    on<LoadGiftTypes>(_onLoadGiftTypes);
    on<LoadReelGifts>(_onLoadReelGifts);
    on<SendGift>(_onSendGift);
  }

  GiftLoaded _ensureLoaded() {
    final s = state;
    if (s is GiftLoaded) return s;
    return const GiftLoaded();
  }

  Future<void> _onLoadGiftTypes(
    LoadGiftTypes event,
    Emitter<GiftState> emit,
  ) async {
    final current = _ensureLoaded();
    if (current.giftTypes.isNotEmpty || current.giftTypesLoading) return;

    emit(current.copyWith(giftTypesLoading: true, giftTypesError: null));
    try {
      final types = await repository.getGiftTypes();
      emit(_ensureLoaded().copyWith(giftTypes: types, giftTypesLoading: false));
    } catch (e) {
      emit(
        _ensureLoaded().copyWith(
          giftTypesLoading: false,
          giftTypesError: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadReelGifts(
    LoadReelGifts event,
    Emitter<GiftState> emit,
  ) async {
    final current = _ensureLoaded();
    if (current.loadingReelGiftIds.contains(event.reelId)) return;

    emit(
      current.copyWith(
        loadingReelGiftIds: {...current.loadingReelGiftIds, event.reelId},
      ),
    );
    try {
      final response = await repository.getReelGifts(event.reelId);
      final updated = _ensureLoaded();
      emit(
        updated.copyWith(
          reelGifts: {...updated.reelGifts, event.reelId: response.gifts},
          loadingReelGiftIds: updated.loadingReelGiftIds
              .where((id) => id != event.reelId)
              .toSet(),
        ),
      );
    } catch (_) {
      final updated = _ensureLoaded();
      emit(
        updated.copyWith(
          loadingReelGiftIds: updated.loadingReelGiftIds
              .where((id) => id != event.reelId)
              .toSet(),
        ),
      );
    }
  }

  Future<void> _onSendGift(SendGift event, Emitter<GiftState> emit) async {
    final current = _ensureLoaded();
    emit(current.copyWith(isSending: true, sendError: null));

    try {
      final gift = await repository.sendGift(
        event.reelId,
        giftTypeId: event.giftTypeId,
        message: event.message,
      );
      final updated = _ensureLoaded();
      final existing = updated.reelGifts[event.reelId] ?? const <GiftModel>[];
      emit(
        updated.copyWith(
          isSending: false,
          lastSentGift: gift,
          reelGifts: {
            ...updated.reelGifts,
            event.reelId: [gift, ...existing],
          },
        ),
      );
    } on GiftSendException catch (e) {
      emit(_ensureLoaded().copyWith(isSending: false, sendError: e.message));
    } catch (e) {
      emit(_ensureLoaded().copyWith(isSending: false, sendError: e.toString()));
    }
  }
}
