import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/utils/FadeRouter.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/favorite_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/bloc/reels_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/data/reels_repository.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_filter_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/player/reel_player_pool.dart';
import 'package:mbium_mobile_client/feature/reels/player/reel_preload_manager.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reel_feed_item.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/shop_detail_screen.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'package:mbium_mobile_client/main.dart';
import 'package:share_plus/share_plus.dart';

/// TikTok-style vertical feed of a single shop's reels, reached by tapping
/// the shop avatar in the main reels feed — replaces the old jump straight
/// into [ShopDetailScreen].
class ShopReelsScreen extends StatelessWidget {
  const ShopReelsScreen({super.key, required this.shop});

  final ReelShop shop;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ReelsBloc(repository: context.read<ReelsRepository>())
            ..add(LoadReels(ReelsFilterModel(shopId: shop.id))),
      child: _ShopReelsView(shop: shop),
    );
  }
}

class _ShopReelsView extends StatefulWidget {
  const _ShopReelsView({required this.shop});

  final ReelShop shop;

  @override
  State<_ShopReelsView> createState() => _ShopReelsViewState();
}

class _ShopReelsViewState extends State<_ShopReelsView> {
  final PageController _pageController = PageController();
  final TextEditingController _commentController = TextEditingController();
  final ReelPlayerPool _playerPool = ReelPlayerPool();
  late final ReelPreloadManager _preloadManager;
  int _currentIndex = 0;
  bool _initialFocusRequested = false;
  List<ReelsModel> _currentReels = const [];
  final Set<int> _likedReelIds = {};

  @override
  void initState() {
    super.initState();
    _preloadManager = ReelPreloadManager(
      pageController: _pageController,
      playerPool: _playerPool,
      videoUrlsProvider: () => _currentReels.map((r) => r.video.url).toList(),
    );
  }

  @override
  void dispose() {
    _preloadManager.dispose();
    _pageController.dispose();
    _playerPool.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index, List<ReelsModel> reels) {
    setState(() => _currentIndex = index);
    _preloadManager.onPageSettleCandidate(index);

    if (index >= reels.length - 2) {
      context.read<ReelsBloc>().add(const LoadMoreReels());
    }
  }

  void _openProduct(ReelProduct product) {
    Navigator.pushNamed(
      context,
      '/productDetail',
      arguments: product.toProductModel(),
    );
  }

  void _openShopProfile() {
    Navigator.push(
      context,
      FadeRoute(page: ShopDetailScreen(shopModel: widget.shop.toShopModel())),
    );
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
            if (state is ReelsLoading || state is ReelsInitial) {
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
              return _buildHeaderOverlay(topPadding);
            }

            final reels = state.reels;
            _currentReels = reels;

            if (reels.isEmpty) {
              return Stack(
                children: [
                  const Center(
                    child: Text(
                      'Reels tapylmady',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  _buildHeaderOverlay(topPadding),
                ],
              );
            }

            if (!_initialFocusRequested) {
              _initialFocusRequested = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _playerPool.focus(
                  _currentIndex,
                  reels.map((r) => r.video.url).toList(),
                );
              });
            }

            return ListenableBuilder(
              listenable: _playerPool,
              builder: (context, _) {
                return PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (i) => _onPageChanged(i, reels),
                  itemCount: reels.length,
                  itemBuilder: (context, index) {
                    final reel = reels[index];
                    final isLiked = _likedReelIds.contains(reel.id);

                    return ReelFeedItem(
                      reel: reel,
                      player: _playerPool.wrapperFor(index),
                      topPadding: topPadding,
                      topBar: _ShopReelsHeader(
                        shop: widget.shop,
                        onOpenShopProfile: _openShopProfile,
                      ),
                      isLiked: isLiked,
                      likeCount: reel.likeCount + (isLiked ? 1 : 0),
                      onDoubleTapLike: () => _onDoubleTapLike(reel),
                      onToggleLike: () => _toggleLike(reel),
                      onOpenProduct: _openProduct,
                      onOpenShop: _openShopProfile,
                      onShare: () => _shareReel(reel),
                      commentController: _commentController,
                      onCommentSubmit: () {},
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderOverlay(double topPadding) {
    return Stack(
      children: [
        Positioned(
          top: topPadding,
          left: 11,
          right: 11,
          child: _ShopReelsHeader(
            shop: widget.shop,
            onOpenShopProfile: _openShopProfile,
          ),
        ),
      ],
    );
  }
}

/// Back button + shop identity — shown in place of the main feed's tab bar
/// so the account this reels list belongs to is always visible.
class _ShopReelsHeader extends StatelessWidget {
  const _ShopReelsHeader({required this.shop, required this.onOpenShopProfile});

  final ReelShop shop;
  final VoidCallback onOpenShopProfile;

  @override
  Widget build(BuildContext context) {
    final logo = shop.logo;
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onOpenShopProfile,
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white70,
                backgroundImage: logo != null && logo.isNotEmpty
                    ? NetworkImage(myMediaUrl + logo)
                    : null,
                child: logo == null || logo.isEmpty
                    ? const Icon(Icons.storefront, size: 16)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                shop.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
