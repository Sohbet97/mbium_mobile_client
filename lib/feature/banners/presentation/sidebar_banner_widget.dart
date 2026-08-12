import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/model/banner_model.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/banner_slide_widget.dart';

/// Carousel of all active `sidebar` banners with a thin Stories-style
/// segmented progress bar instead of dots — distinct from the floating card
/// carousel used on the home feed. Renders nothing when there are none.
class SidebarBannerWidget extends StatefulWidget {
  const SidebarBannerWidget({super.key});

  @override
  State<SidebarBannerWidget> createState() => _SidebarBannerWidgetState();
}

class _SidebarBannerWidgetState extends State<SidebarBannerWidget> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerState = context.watch<BannerBloc>().state;
    final banners = bannerState is BannerLoaded
        ? bannerState
              .bannersByType('sidebar')
              .where((b) => b.isCurrentlyActive)
              .toList()
        : const <BannerModel>[];

    if (banners.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: banners.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) =>
                  BannerSlideWidget(banner: banners[index]),
            ),
            if (banners.length > 1)
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Row(
                  children: List.generate(banners.length, (i) {
                    final reached = i <= _currentIndex;
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: EdgeInsets.only(
                          right: i == banners.length - 1 ? 0 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: reached
                              ? AppColors.alibabaOrange
                              : Colors.white.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
