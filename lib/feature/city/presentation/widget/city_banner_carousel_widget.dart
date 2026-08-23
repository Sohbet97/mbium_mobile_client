import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/model/banner_model.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/banner_carousel_indicator.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/banner_slide_widget.dart';

/// Swipeable carousel of active `city` banners — replaces the old static
/// delivery/coin card at the bottom of [CityPage] so this placement is
/// admin-managed like every other banner slot in the app.
///
/// Built on [CarouselSlider] with autoplay enabled: the centered card sits
/// at full scale/opacity while its neighbors peek in on each side, scaled
/// down and dimmed. Renders nothing when there are no active `city`
/// banners.
class CityBannerCarouselWidget extends StatefulWidget {
  const CityBannerCarouselWidget({super.key});

  @override
  State<CityBannerCarouselWidget> createState() =>
      _CityBannerCarouselWidgetState();
}

class _CityBannerCarouselWidgetState extends State<CityBannerCarouselWidget> {
  final ValueNotifier<double> _page = ValueNotifier(0);
  int _currentIndex = 0;

  @override
  void dispose() {
    _page.dispose();
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

    final canLoop = banners.length > 1;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            viewportFraction: 0.68,
            enableInfiniteScroll: canLoop,
            autoPlay: canLoop,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 600),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, _) => setState(() => _currentIndex = index),
            onScrolled: (page) =>
                _page.value = page ?? _currentIndex.toDouble(),
          ),
          itemBuilder: (context, index, realIndex) {
            return ValueListenableBuilder<double>(
              valueListenable: _page,
              builder: (context, page, child) {
                final distance = (page - realIndex).abs().clamp(0.0, 1.0);
                final scale = 1 - (distance * 0.11);
                final opacity = 1 - (distance * 0.35);

                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(scale: scale, child: child),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BannerSlideWidget(
                    banner: banners[index],
                    compact: true,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        BannerCarouselIndicator(
          count: banners.length,
          currentIndex: _currentIndex,
        ),
      ],
    );
  }
}
