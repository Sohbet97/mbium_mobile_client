import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/reels/models/gift_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/player/reel_player_wrapper.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/gift_picker_sheet.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reel_player_view.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_comment_input.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_description_widget.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_profile_header.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'package:mbium_mobile_client/main.dart';

/// One full-screen reel: video surface + all overlays. Shared by the main
/// reels feed and [ShopReelsScreen] — [topBar] is the only part that differs
/// between the two (feed tab bar vs. a shop header with a back button).
class ReelFeedItem extends StatefulWidget {
  const ReelFeedItem({
    super.key,
    required this.reel,
    required this.player,
    required this.topPadding,
    required this.topBar,
    required this.isLiked,
    required this.likeCount,
    required this.onDoubleTapLike,
    required this.onToggleLike,
    required this.onOpenProduct,
    required this.onOpenShop,
    required this.onShare,
    required this.commentController,
    required this.onCommentSubmit,
  });

  final ReelsModel reel;
  final ReelPlayerWrapper? player;
  final double topPadding;
  final Widget topBar;
  final bool isLiked;
  final int likeCount;
  final VoidCallback onDoubleTapLike;
  final VoidCallback onToggleLike;
  final void Function(ReelProduct product) onOpenProduct;
  final VoidCallback onOpenShop;
  final VoidCallback onShare;
  final TextEditingController commentController;
  final VoidCallback onCommentSubmit;

  @override
  State<ReelFeedItem> createState() => _ReelFeedItemState();
}

class _ReelFeedItemState extends State<ReelFeedItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _giftController;
  late final Animation<Offset> _giftOffset;
  late final Animation<double> _giftOpacity;

  int _extraGiftCount = 0;
  String? _flyingGiftImageUrl;

  @override
  void initState() {
    super.initState();
    _giftController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _giftOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2.2),
    ).animate(CurvedAnimation(parent: _giftController, curve: Curves.easeOut));
    _giftOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_giftController);
  }

  @override
  void dispose() {
    _giftController.dispose();
    super.dispose();
  }

  Future<void> _openGiftSheet() async {
    // Awaiting the route means the flying-gift animation only starts once
    // this sheet is actually gone — starting it on send-success instead
    // played it hidden underneath the still-open sheet.
    final gift = await showModalBottomSheet<GiftModel>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => GiftPickerSheet(reelId: widget.reel.id),
    );
    if (gift == null || !mounted) return;

    setState(() {
      _extraGiftCount++;
      _flyingGiftImageUrl = gift.giftType.animation?.url;
    });
    _giftController.forward(from: 0);
  }

  String _formatCount(int count) {
    if (count < 1000) return '$count';
    if (count < 1000000) {
      final value = count / 1000;
      return '${value.toStringAsFixed(value < 10 ? 1 : 0)}K';
    }
    final value = count / 1000000;
    return '${value.toStringAsFixed(value < 10 ? 1 : 0)}M';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ReelPlayerView(
          reel: widget.reel,
          player: widget.player,
          onDoubleTapLike: widget.onDoubleTapLike,
        ),
        Positioned(
          top: widget.topPadding,
          left: 11,
          right: 11,
          child: widget.topBar,
        ),
        Positioned(
          top: widget.topPadding + 60,
          left: 11,
          right: 11,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ReelsProfileHeader(
                reel: widget.reel,
                onOpenShop: widget.onOpenShop,
                onOpenGiftSheet: _openGiftSheet,
              ),
              const SizedBox(height: 12),
              ReelsDescriptionWidget(caption: widget.reel.caption),
              const SizedBox(height: 8),
              Row(children: [_buildAddToBasketButton(context)]),
            ],
          ),
        ),
        Positioned(right: 11, bottom: 85, child: _buildRightActions(context)),
        Positioned(
          left: 11,
          right: 11,
          bottom: 15,
          child: SafeArea(
            top: false,
            child: ReelsCommentInput(
              controller: widget.commentController,
              onSubmit: widget.onCommentSubmit,
            ),
          ),
        ),
        if (_flyingGiftImageUrl != null) _buildFlyingGift(),
      ],
    );
  }

  Widget _buildFlyingGift() {
    final imageUrl = _flyingGiftImageUrl!;
    return Positioned(
      right: 26,
      bottom: 160,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _giftController,
          builder: (context, child) {
            return Opacity(
              opacity: _giftOpacity.value,
              child: FractionalTranslation(
                translation: _giftOffset.value,
                child: child,
              ),
            );
          },
          child: imageUrl.isNotEmpty
              ? CachedNetworkImage(imageUrl: imageUrl, width: 56, height: 56)
              : const Icon(Icons.card_giftcard, color: Colors.white, size: 48),
        ),
      ),
    );
  }

  Widget _buildAddToBasketButton(BuildContext context) {
    final product = widget.reel.product;
    if (product == null) return const SizedBox.shrink();

    final localization = S.of(context);
    return GestureDetector(
      onTap: () => widget.onOpenProduct(product),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondaryGreen),
        ),
        child: Row(
          children: [
            SvgIcon(
              iconName: 'assets/icons/shopping_basket.svg',
              height: 14,
              width: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 4),
            Text(
              localization.sebede_gos,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightActions(BuildContext context) {
    final product = widget.reel.product;
    final logo = widget.reel.shop.logo;

    return Column(
      children: [
        GestureDetector(
          onTap: widget.onOpenShop,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white24,
              border: Border.all(color: Colors.white, width: 1.5),
              image: logo != null && logo.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(myMediaUrl + logo),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: logo == null || logo.isEmpty
                ? const Icon(Icons.storefront, color: Colors.white, size: 22)
                : null,
          ),
        ),
        const SizedBox(height: 20),
        _actionButton(
          icon: widget.isLiked ? Icons.favorite : Icons.favorite_border,
          iconColor: widget.isLiked ? const Color(0xFFFE2C55) : Colors.white,
          label: _formatCount(widget.likeCount),
          onTap: widget.onToggleLike,
        ),
        const SizedBox(height: 8),
        if (product != null) ...[
          _actionButton(
            icon: Icons.shopping_bag,
            onTap: () => widget.onOpenProduct(product),
          ),
          const SizedBox(height: 8),
        ],
        _actionButton(
          icon: Icons.card_giftcard,
          label: _formatCount(widget.reel.giftCount + _extraGiftCount),
          onTap: _openGiftSheet,
        ),
        const SizedBox(height: 8),
        _actionButton(icon: Icons.reply, label: 'Share', onTap: widget.onShare),
        const SizedBox(height: 18),
        _actionButton(
          icon: Icons.remove_red_eye,
          label: _formatCount(widget.reel.viewCount),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    String? label,
    Color iconColor = Colors.white,
    VoidCallback? onTap,
  }) {
    const shadows = [
      Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 1)),
    ];

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 30, shadows: shadows),
          if (label != null) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                shadows: shadows,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
