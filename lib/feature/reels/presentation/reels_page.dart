import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/reels/bloc/reels_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_filter_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/player/reel_player_pool.dart';
import 'package:mbium_mobile_client/feature/reels/player/reel_preload_manager.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reel_player_view.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_comment_input.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_profile_header.dart';
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
  final PageController _pageController = PageController();
  final TextEditingController textEditingController = TextEditingController();
  final ReelPlayerPool _playerPool = ReelPlayerPool();
  late final ReelPreloadManager _preloadManager;
  int _currentIndex = 0;
  bool _initialFocusRequested = false;
  List<ReelsModel> _currentReels = const [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 2);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onTabChanged();
      }
    });
    context.read<ReelsBloc>().add(LoadReels(const ReelsFilterModel()));

    _preloadManager = ReelPreloadManager(
      pageController: _pageController,
      playerPool: _playerPool,
      videoUrlsProvider: () => _currentReels.map((r) => r.video.url).toList(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _preloadManager.dispose();
    _pageController.dispose();
    _playerPool.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    _playerPool.reset();
    setState(() {
      _currentIndex = 0;
      _initialFocusRequested = false;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
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

  void _openShop(ReelShop shop) {
    Navigator.pushNamed(context, '/shopDetail', arguments: shop.toShopModel());
  }

  void _shareReel(ReelsModel reel) {
    Share.share('${reel.caption}\n${reel.video.url}');
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
            _currentReels = reels;

            if (reels.isEmpty) {
              return Stack(
                children: [
                  const Center(
                    child: Text(
                      "Reels tapylmady",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 16,
                    right: 16,
                    child: ReelsTabBar(tabController: _tabController),
                  ),
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

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ReelPlayerView(
                          reel: reel,
                          player: _playerPool.wrapperFor(index),
                        ),

                        Positioned(
                          top: topPadding,
                          left: 11,
                          right: 11,
                          child: ReelsTabBar(tabController: _tabController),
                        ),

                        Positioned(
                          top: topPadding + 60,
                          left: 11,
                          right: 11,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ReelsProfileHeader(reel: reel),
                              const SizedBox(height: 12),
                              _buildDescription(reel),
                              const SizedBox(height: 8),
                              Row(children: [_buildAddToBasketButton(reel)]),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 11,
                          bottom: 85,
                          child: _buildRightActions(reel),
                        ),
                        Positioned(
                          left: 11,
                          right: 11,
                          bottom: 15,
                          child: SafeArea(
                            top: false,
                            child: ReelsCommentInput(
                              controller: textEditingController,
                              onSubmit: () {},
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildDescription(ReelsModel reel) {
    if (reel.caption.isEmpty) return const SizedBox.shrink();
    return Text(
      reel.caption,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAddToBasketButton(ReelsModel reel) {
    final product = reel.product;
    if (product == null) return const SizedBox.shrink();

    final localization = S.of(context);
    return GestureDetector(
      onTap: () => _openProduct(product),
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

  Widget _buildRightActions(ReelsModel reel) {
    final product = reel.product;
    return Column(
      children: [
        _iconButton(Icons.visibility_outlined, count: reel.viewCount),
        const SizedBox(height: 10),
        _iconButton(Icons.share_sharp, onTap: () => _shareReel(reel)),
        const SizedBox(height: 10),
        if (product != null) ...[
          _iconButton(
            Icons.shopping_bag_outlined,
            onTap: () => _openProduct(product),
          ),
          const SizedBox(height: 10),
        ],
        _iconButton(
          Icons.storefront_outlined,
          onTap: () => _openShop(reel.shop),
        ),
      ],
    );
  }

  Widget _iconButton(IconData icon, {int? count, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          if (count != null) ...[
            const SizedBox(height: 4),
            Text('$count', style: const TextStyle(color: Colors.white)),
          ],
        ],
      ),
    );
  }
}
