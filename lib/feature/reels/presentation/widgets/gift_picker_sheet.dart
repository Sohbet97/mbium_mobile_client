import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cupons/bloc/coin_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/bloc/gift_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/models/gift_model.dart';

/// TikTok-style gift sheet for one reel: a "send" tab (catalog grid) and a
/// "gifts" tab (who already gifted this reel). Sends via [GiftBloc],
/// refreshes the shared coin balance ([CoinBloc]) on success, then pops
/// itself with the sent [GiftModel] as the route result — the caller
/// (`ReelFeedItem`) uses that to play the flying-gift animation only once
/// this sheet is actually gone, instead of racing it underneath the sheet.
class GiftPickerSheet extends StatefulWidget {
  const GiftPickerSheet({super.key, required this.reelId});

  final int reelId;

  @override
  State<GiftPickerSheet> createState() => _GiftPickerSheetState();
}

class _GiftPickerSheetState extends State<GiftPickerSheet> {
  int? _sendingGiftTypeId;
  GiftModel? _confirmedGift;

  @override
  void initState() {
    super.initState();
    context.read<GiftBloc>().add(const LoadGiftTypes());
    context.read<GiftBloc>().add(LoadReelGifts(widget.reelId));
    context.read<CoinBloc>().add(LoadCoinBalanceEvent());
  }

  void _send(GiftTypeModel giftType) {
    if (_sendingGiftTypeId != null) return;
    setState(() => _sendingGiftTypeId = giftType.id);
    context.read<GiftBloc>().add(
      SendGift(reelId: widget.reelId, giftTypeId: giftType.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GiftBloc, GiftState>(
          listenWhen: (previous, current) {
            if (current is! GiftLoaded) return false;
            final previousGift = previous is GiftLoaded
                ? previous.lastSentGift
                : null;
            return current.lastSentGift != null &&
                current.lastSentGift != previousGift &&
                current.lastSentGift!.reelId == widget.reelId;
          },
          listener: (context, state) async {
            final gift = (state as GiftLoaded).lastSentGift!;
            context.read<CoinBloc>().add(LoadCoinBalanceEvent());
            setState(() {
              _sendingGiftTypeId = null;
              _confirmedGift = gift;
            });
            await Future.delayed(const Duration(milliseconds: 500));
            if (context.mounted) Navigator.of(context).pop(gift);
          },
        ),
        BlocListener<GiftBloc, GiftState>(
          listenWhen: (previous, current) {
            if (current is! GiftLoaded) return false;
            final previousError = previous is GiftLoaded
                ? previous.sendError
                : null;
            return current.sendError != null &&
                current.sendError != previousError;
          },
          listener: (context, state) {
            setState(() => _sendingGiftTypeId = null);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((state as GiftLoaded).sendError!),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.62,
          decoration: const BoxDecoration(
            color: Color(0xFF161616),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildHeader(),
              const TabBar(
                tabs: [
                  Tab(text: 'Iber'),
                  Tab(text: 'Sowgatlar'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white54,
                indicatorColor: AppColors.secondaryGreen,
                dividerColor: Colors.white12,
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _confirmedGift != null
                        ? _buildConfirmation(_confirmedGift!)
                        : _buildSendGrid(),
                    _buildGiftsHistory(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          const Text(
            'Sowgatlar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          BlocBuilder<CoinBloc, CoinState>(
            builder: (context, state) {
              final balance = state is CoinLoaded ? state.coin.balance : null;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      balance != null ? balance.toStringAsFixed(0) : '—',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSendGrid() {
    return BlocBuilder<GiftBloc, GiftState>(
      builder: (context, state) {
        if (state is! GiftLoaded ||
            (state.giftTypesLoading && state.giftTypes.isEmpty)) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white54),
          );
        }

        if (state.giftTypesError != null && state.giftTypes.isEmpty) {
          return Center(
            child: Text(
              state.giftTypesError!,
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }

        final giftTypes = state.giftTypes;
        if (giftTypes.isEmpty) {
          return const Center(
            child: Text(
              'Sowgat görnüşi ýok',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
          ),
          itemCount: giftTypes.length,
          itemBuilder: (context, index) {
            final giftType = giftTypes[index];
            final isSending = _sendingGiftTypeId == giftType.id;
            final isDisabled = _sendingGiftTypeId != null && !isSending;

            return _GiftTile(
              giftType: giftType,
              isSending: isSending,
              isDisabled: isDisabled,
              onTap: () => _send(giftType),
            );
          },
        );
      },
    );
  }

  Widget _buildConfirmation(GiftModel gift) {
    final imageUrl = gift.giftType.animation?.url;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.contain,
            )
          else
            const Icon(Icons.card_giftcard, color: Colors.white, size: 56),
          const SizedBox(height: 12),
          Text(
            gift.giftType.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Iberildi!', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildGiftsHistory() {
    return BlocBuilder<GiftBloc, GiftState>(
      builder: (context, state) {
        if (state is! GiftLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white54),
          );
        }

        final isLoading = state.loadingReelGiftIds.contains(widget.reelId);
        final gifts = state.reelGifts[widget.reelId] ?? const <GiftModel>[];

        if (isLoading && gifts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white54),
          );
        }

        if (gifts.isEmpty) {
          return const Center(
            child: Text(
              'Entek sowgat ýok',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: gifts.length,
          separatorBuilder: (_, _) =>
              const Divider(color: Colors.white12, height: 1),
          itemBuilder: (context, index) {
            final gift = gifts[index];
            final imageUrl =
                gift.giftType.animation?.url ?? gift.giftType.icon?.url;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                          )
                        : const Icon(
                            Icons.card_giftcard,
                            color: Colors.white,
                            size: 28,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gift.user.fullName.isNotEmpty
                              ? gift.user.fullName
                              : 'Ulanyjy',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          gift.giftType.name,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${gift.priceCoin}',
                        style: const TextStyle(
                          color: AppColors.secondaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _GiftTile extends StatelessWidget {
  const _GiftTile({
    required this.giftType,
    required this.isSending,
    required this.isDisabled,
    required this.onTap,
  });

  final GiftTypeModel giftType;
  final bool isSending;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = giftType.animation?.url ?? giftType.icon?.url;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1,
      child: GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: isSending
                    ? const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : (imageUrl != null && imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.contain,
                            )
                          : const Icon(
                              Icons.card_giftcard,
                              color: Colors.white,
                              size: 32,
                            )),
              ),
              const SizedBox(height: 6),
              Text(
                giftType.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/coin_image.png',
                    height: 17,
                    width: 17,
                    fit: BoxFit.cover,
                  ),

                  const SizedBox(width: 2),
                  Text(
                    '${giftType.priceCoin}',
                    style: const TextStyle(
                      color: AppColors.navBarGrey,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
