import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/model/banner_model.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/banner_carousel_indicator.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/banner_slide_widget.dart';

const _bannersPerCarousel = 5;

/// One grid slot holding a swipeable carousel of up to [_bannersPerCarousel]
/// active home_hero banners, picked starting at [insertionIndex] * 5 and
/// wrapping around via modulo — so each inserted slot shows a different
/// window of the banner list, cycling once the list is exhausted.
class HomeBannerWidget extends StatefulWidget {
  final int insertionIndex;

  const HomeBannerWidget({super.key, required this.insertionIndex});

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
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
    final allBanners = bannerState is BannerLoaded
        ? bannerState
              .bannersByType('home_hero')
              .where((b) => b.isCurrentlyActive)
              .toList()
        : const <BannerModel>[];

    if (allBanners.isEmpty) return const SizedBox.shrink();

    final slideCount = allBanners.length < _bannersPerCarousel
        ? allBanners.length
        : _bannersPerCarousel;
    final banners = List.generate(
      slideCount,
      (i) =>
          allBanners[(widget.insertionIndex * _bannersPerCarousel + i) %
              allBanners.length],
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 0.65,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemCount: banners.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) =>
                  BannerSlideWidget(banner: banners[index]),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BannerCarouselIndicator(
                count: banners.length,
                currentIndex: _currentIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
