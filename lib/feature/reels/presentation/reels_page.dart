import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/utils/FadeRouter.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/favorite_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/bloc/reels_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_filter_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/player/reel_player_pool.dart';
import 'package:mbium_mobile_client/feature/reels/player/reel_preload_manager.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/shop_reels_screen.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reel_feed_item.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_tab_bar.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'package:share_plus/share_plus.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({super.key});

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController textEditingController = TextEditingController();
  final Set<int> _likedReelIds = {};
  bool _commentsOpen = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);
    context.read<ReelsBloc>().add(LoadReels(const ReelsFilterModel()));
  }

  @override
  void dispose() {
    _tabController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void _openProduct(ReelProduct product) {
    Navigator.pushNamed(
      context,
      '/productDetail',
      arguments: product.toProductModel(),
    );
  }

  void _openShop(ReelShop shop) {
    Navigator.push(context, FadeRoute(page: ShopReelsScreen(shop: shop)));
  }

  void _shareReel(ReelsModel reel) {
    Share.share('${reel.caption}\n${reel.video.url}');
  }

  void _toggleLike(ReelsModel reel) {
    HapticFeedback.lightImpact();
    setState(() {
      if (!_likedReelIds.remove(reel.id)) {
        _likedReelIds.add(reel.id);
        context.read<ReelsBloc>().add(LikeReel(reel.id));
      }
    });
  }

  // Double tap on the video only ever likes, never un-likes — same as TikTok.
  void _onDoubleTapLike(ReelsModel reel) {
    if (_likedReelIds.add(reel.id)) {
      setState(() {});
      context.read<ReelsBloc>().add(LikeReel(reel.id));
    }

    final product = reel.product;
    if (product != null) {
      context.read<FavoriteBloc>().add(
        AddFavoriteProduct(product.toProductModel()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        body: BlocBuilder<ReelsBloc, ReelsState>(
          builder: (context, state) {
            if (state is ReelsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ReelsError) {
              MyHelpers.showMessage(
                localization.nasazlyk_yuze_cykdy,
                Colors.red,
                context,
              );
            }

            if (state is! ReelsLoaded) {
              return const SizedBox();
            }

            final reels = state.reels;

            return Stack(
              children: [
                // Horizontal finger-swipe between tabs — each tab keeps its
                // own vertical feed/scroll/player state (below), so swiping
                // away and back doesn't reset where you were.
                TabBarView(
                  controller: _tabController,
                  children: List.generate(
                    3,
                    (tabIndex) => _ReelsFeedView(
                      tabIndex: tabIndex,
                      tabController: _tabController,
                      reels: reels,
                      topPadding: topPadding,
                      likedReelIds: _likedReelIds,
                      onDoubleTapLike: _onDoubleTapLike,
                      onToggleLike: _toggleLike,
                      onOpenProduct: _openProduct,
                      onOpenShop: _openShop,
                      onShare: _shareReel,
                      commentController: textEditingController,
                      onLoadMore: () =>
                          context.read<ReelsBloc>().add(const LoadMoreReels()),
                      onCommentsOpenChanged: (open) =>
                          setState(() => _commentsOpen = open),
                    ),
                  ),
                ),
                // Rendered once here, not per feed item — it's the same tab
                // bar regardless of which reel/tab is on screen. Hidden
                // while a reel's comments panel is open, same as the
                // per-item chrome inside ReelFeedItem.
                if (!_commentsOpen)
                  Positioned(
                    top: topPadding,
                    left: 11,
                    right: 11,
                    child: ReelsTabBar(tabController: _tabController),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// One tab's vertical reel feed. Each tab owns its own [PageController] /
/// [ReelPlayerPool] so [TabBarView] can keep all three built for instant
/// horizontal swiping without their video players fighting each other —
/// only the currently active tab actually plays anything.
class _ReelsFeedView extends StatefulWidget {
  const _ReelsFeedView({
    required this.tabIndex,
    required this.tabController,
    required this.reels,
    required this.topPadding,
    required this.likedReelIds,
    required this.onDoubleTapLike,
    required this.onToggleLike,
    required this.onOpenProduct,
    required this.onOpenShop,
    required this.onShare,
    required this.commentController,
    required this.onLoadMore,
    required this.onCommentsOpenChanged,
  });

  final int tabIndex;
  final TabController tabController;
  final List<ReelsModel> reels;
  final double topPadding;
  final Set<int> likedReelIds;
  final void Function(ReelsModel reel) onDoubleTapLike;
  final void Function(ReelsModel reel) onToggleLike;
  final void Function(ReelProduct product) onOpenProduct;
  final void Function(ReelShop shop) onOpenShop;
  final void Function(ReelsModel reel) onShare;
  final TextEditingController commentController;
  final VoidCallback onLoadMore;
  final ValueChanged<bool> onCommentsOpenChanged;

  @override
  State<_ReelsFeedView> createState() => _ReelsFeedViewState();
}

class _ReelsFeedViewState extends State<_ReelsFeedView> {
  final PageController _pageController = PageController();
  final ReelPlayerPool _playerPool = ReelPlayerPool();
  late final ReelPreloadManager _preloadManager;
  int _currentIndex = 0;
  bool _wasActive = false;

  bool get _isActive => widget.tabController.index == widget.tabIndex;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_onTabControllerChanged);

    _preloadManager = ReelPreloadManager(
      pageController: _pageController,
      playerPool: _playerPool,
      videoUrlsProvider: () => widget.reels.map((r) => r.video.url).toList(),
    );

    _wasActive = _isActive;
    if (_wasActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusCurrent());
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onTabControllerChanged);
    _preloadManager.dispose();
    _pageController.dispose();
    _playerPool.dispose();
    super.dispose();
  }

  // Fires continuously while a swipe/animation is in flight — only act when
  // this tab actually crosses into/out of being the active one.
  void _onTabControllerChanged() {
    final isActive = _isActive;
    if (isActive == _wasActive) return;
    _wasActive = isActive;

    if (isActive) {
      _focusCurrent();
    } else {
      _playerPool.reset();
    }
  }

  void _focusCurrent() {
    if (widget.reels.isEmpty) return;
    _playerPool.focus(
      _currentIndex,
      widget.reels.map((r) => r.video.url).toList(),
    );
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    _preloadManager.onPageSettleCandidate(index);

    if (index >= widget.reels.length - 2) {
      widget.onLoadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reels.isEmpty) {
      return const Center(
        child: Text('Reels tapylmady', style: TextStyle(color: Colors.white)),
      );
    }

    return ListenableBuilder(
      listenable: _playerPool,
      builder: (context, _) {
        return PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: _onPageChanged,
          itemCount: widget.reels.length,
          itemBuilder: (context, index) {
            final reel = widget.reels[index];
            final isLiked = widget.likedReelIds.contains(reel.id);

            return ReelFeedItem(
              reel: reel,
              player: _playerPool.wrapperFor(index),
              topPadding: widget.topPadding,
              isLiked: isLiked,
              likeCount: reel.likeCount + (isLiked ? 1 : 0),
              onDoubleTapLike: () => widget.onDoubleTapLike(reel),
              onToggleLike: () => widget.onToggleLike(reel),
              onOpenProduct: widget.onOpenProduct,
              onOpenShop: () => widget.onOpenShop(reel.shop),
              onShare: () => widget.onShare(reel),
              commentController: widget.commentController,
              onCommentSubmit: () {},
              onCommentsOpenChanged: widget.onCommentsOpenChanged,
            );
          },
        );
      },
    );
  }
}
