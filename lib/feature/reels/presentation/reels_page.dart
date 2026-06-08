import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/reels/bloc/reels_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_filter_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_comment_input.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_profile_header.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/widgets/reels_tab_bar.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'package:video_player/video_player.dart';

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
  final Map<int, VideoPlayerController> _controllers = {};
  int _currentIndex = 0;
  final Map<int, bool> _paused = {};

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {
      _currentIndex = 0;
      for (final c in _controllers.values) {
        c.dispose();
      }
      _controllers.clear();
      _paused.clear();

      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    });
  }

  Future<void> _initVideo(int index, ReelsModel reel) async {
    if (_controllers.containsKey(index)) return;

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(reel.videoUrl),
    );

    _controllers[index] = controller;
    _paused[index] = false;

    try {
      await controller.initialize();
      controller.setLooping(true);

      if (index == _currentIndex && _paused[index] != true) {
        controller.play();
      }

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Video init error: $e");
    }
  }

  void _onPageChanged(int index, List<ReelsModel> reels) {
    setState(() => _currentIndex = index);

    _controllers.forEach((i, c) {
      if (i != index) {
        c.pause();
      } else {
        if (_paused[i] != true) {
          c.play();
        }
      }
    });

    if (index >= reels.length - 2) {
      context.read<ReelsBloc>().add(const LoadMoreReels());
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
            return PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (i) => _onPageChanged(i, reels),
              itemCount: reels.length,
              itemBuilder: (context, index) {
                final reel = reels[index];
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _initVideo(index, reel);
                });
                final controller = _controllers[index];

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    controller != null && controller.value.isInitialized
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),

                    Container(color: Colors.black26),

                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          final c = _controllers[index];
                          if (c == null) return;

                          setState(() {
                            if (c.value.isPlaying) {
                              c.pause();
                              _paused[index] = true;
                            } else {
                              c.play();
                              _paused[index] = false;
                            }
                          });
                        },
                      ),
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
                          Row(children: [_buildAddToBasketButton()]),
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
                    //
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDescription(ReelsModel reel) {
    return Text(
      reel.titleTm ?? '',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAddToBasketButton() {
    final localization = S.of(context);
    return Container(
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
    );
  }

  Widget _buildRightActions(ReelsModel reel) {
    return Column(
      children: [
        _iconButton(Icons.star, reel.starCount),
        const SizedBox(height: 10),
        _iconButton(Icons.comment, reel.commentCount),
        const SizedBox(height: 10),
        _iconButton(Icons.bookmark_border, reel.favoriteCount),
        const SizedBox(height: 10),
        _iconButton(Icons.reply, reel.shareCount),
      ],
    );
  }

  Widget _iconButton(IconData icon, int count) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 4),
        Text('$count', style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
