import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/reels/models/gift_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/player/reel_player_wrapper.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/comments_sheet.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/gift_picker_sheet.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reel_player_view.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_description_widget.dart';
import 'package:mbium_mobile_client/main.dart';

/// One full-screen reel: video surface + all overlays. Shared by the main
/// reels feed and [ShopReelsScreen].
///
/// [topBar] is optional: [ShopReelsScreen] passes its own per-item shop
/// header here, but the main feed's [ReelsTabBar] is rendered once, outside
/// the swipeable [PageView] — not per item — so [ReelsPage] leaves it null.
class ReelFeedItem extends StatefulWidget {
  const ReelFeedItem({
    super.key,
    required this.reel,
    required this.player,
    required this.topPadding,
    this.topBar,
    required this.isLiked,
    required this.likeCount,
    required this.onDoubleTapLike,
    required this.onToggleLike,
    required this.onOpenProduct,
    required this.onOpenShop,
    required this.onShare,
    required this.commentController,
    required this.onCommentSubmit,
    this.onCommentsOpenChanged,
  });

  final ReelsModel reel;
  final ReelPlayerWrapper? player;
  final double topPadding;
  final Widget? topBar;

  /// Reports open/closed whenever the comments panel toggles — lets a
  /// parent that renders its own chrome outside this widget (e.g.
  /// [ReelsPage]'s shared [ReelsTabBar]) hide it in sync.
  final ValueChanged<bool>? onCommentsOpenChanged;
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
  bool _commentsOpen = false;

  /// Shared with [ReelPlayerView]: a tap anywhere on the video collapses the
  /// caption instead of toggling playback while it's expanded.
  final ValueNotifier<bool> _captionExpanded = ValueNotifier<bool>(false);

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
    _captionExpanded.dispose();
    super.dispose();
  }

  bool _onScreenTap() {
    if (_captionExpanded.value) {
      _captionExpanded.value = false;
      return true;
    }
    return false;
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

  void _toggleComments() {
    setState(() => _commentsOpen = !_commentsOpen);
    widget.onCommentsOpenChanged?.call(_commentsOpen);
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
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: _commentsOpen
                ? const BorderRadius.vertical(bottom: Radius.circular(16))
                : BorderRadius.zero,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ReelPlayerView(
                  reel: widget.reel,
                  player: widget.player,
                  onDoubleTapLike: widget.onDoubleTapLike,
                  onScreenTap: _onScreenTap,
                  fit: _commentsOpen ? BoxFit.contain : BoxFit.cover,
                  showProgressBar: !_commentsOpen,
                ),

                if (!_commentsOpen && widget.topBar != null)
                  Positioned(
                    top: widget.topPadding,
                    left: 11,
                    right: 11,
                    child: widget.topBar!,
                  ),
                if (!_commentsOpen)
                  Positioned(
                    bottom: 5,
                    left: 11,
                    right: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ReelsProfileHeader(
                        //   reel: widget.reel,
                        //   onOpenShop: widget.onOpenShop,
                        //   onOpenGiftSheet: _openGiftSheet,
                        // ),
                        const SizedBox(height: 12),
                        ReelsDescriptionWidget(
                          caption: widget.reel.caption,
                          shopName: widget.reel.shop,
                          expandedNotifier: _captionExpanded,
                          onTapShopName: () => widget.player?.pause(),
                        ),
                        const SizedBox(height: 8),
                        // Row(children: [_buildAddToBasketButton(context)]),
                      ],
                    ),
                  ),
                if (!_commentsOpen)
                  Positioned(
                    right: 11,
                    bottom: 55,
                    child: _buildRightActions(context),
                  ),
                if (_flyingGiftImageUrl != null) _buildFlyingGift(),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _commentsOpen
              ? CommentsSheet(
                  commentController: widget.commentController,
                  onSubmit: widget.onCommentSubmit,
                  onClose: _toggleComments,
                )
              : const SizedBox.shrink(),
        ),
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

  Widget _buildRightActions(BuildContext context) {
    final product = widget.reel.product;
    final logo = widget.reel.shop.logo;

    return Column(
      children: [
        GestureDetector(
          onTap: widget.onOpenShop,
          child: Container(
            width: 40,
            height: 40,
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
        const SizedBox(height: 12),
        _actionButton(
          icon: widget.isLiked ? Icons.star : Icons.star_border,
          size: 35,
          iconColor: widget.isLiked
              ? const Color.fromARGB(255, 240, 208, 28)
              : Colors.white,
          label: _formatCount(widget.likeCount),
          onTap: widget.onToggleLike,
        ),
        const SizedBox(height: 8),
        _actionButton(icon: Icons.comment_outlined, onTap: _toggleComments),
        const SizedBox(height: 8),
        if (product != null) ...[
          _actionButton(
            icon: Icons.shopping_bag_outlined,
            onTap: () => widget.onOpenProduct(product),
            label: widget.reel.product!.price.toStringAsFixed(2),
          ),
          const SizedBox(height: 8),
        ],
        _actionButton(
          icon: Icons.card_giftcard,
          label: _formatCount(widget.reel.giftCount + _extraGiftCount),
          onTap: _openGiftSheet,
        ),
        const SizedBox(height: 8),
        _actionButton(
          icon: Icons.share_outlined,
          label: '0',
          onTap: widget.onShare,
        ),
        // const SizedBox(height: 18),
        // _actionButton(
        //   icon: Icons.remove_red_eye,
        //   label: _formatCount(widget.reel.viewCount),
        // ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    String? label,
    Color iconColor = Colors.white,
    VoidCallback? onTap,
    double? size,
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
          Icon(icon, color: iconColor, size: size ?? 30, shadows: shadows),
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
