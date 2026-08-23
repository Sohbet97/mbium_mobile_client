import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';

/// Swipeable image carousel for a grid card — finger-drag via [PageView],
/// plus auto-advance every 2s while more than one image exists. [currentIndex]
/// still drives it externally (e.g. the parent's arrow-tap buttons); swipes
/// and auto-advance report back out through [onPageChanged] so the parent's
/// index (dots, arrow visibility) stays in sync either way.
class ProductGridImageCarouselWidget extends StatefulWidget {
  final List<ProductMedia> media;
  final int currentIndex;
  final ValueChanged<int>? onPageChanged;

  const ProductGridImageCarouselWidget({
    super.key,
    required this.media,
    required this.currentIndex,
    this.onPageChanged,
  });

  @override
  State<ProductGridImageCarouselWidget> createState() =>
      _ProductGridImageCarouselWidgetState();
}

class _ProductGridImageCarouselWidgetState
    extends State<ProductGridImageCarouselWidget> {
  static const _autoPlayInterval = Duration(seconds: 2);

  late final PageController _pageController;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
    _startAutoPlay();
  }

  @override
  void didUpdateWidget(covariant ProductGridImageCarouselWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentIndex != oldWidget.currentIndex &&
        _pageController.hasClients &&
        _pageController.page?.round() != widget.currentIndex) {
      _pageController.animateToPage(
        widget.currentIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }

    if (widget.media.length != oldWidget.media.length) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.media.length <= 1) return;

    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (widget.currentIndex + 1) % widget.media.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    widget.onPageChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.media;
    if (media.isEmpty) return _placeholder();

    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            // PageView needs a bounded height (unlike the old crossfade,
            // which just took on the loaded image's own size) — a fixed
            // aspect ratio is the simplest way to give it one without
            // measuring every image up front.
            child: AspectRatio(
              aspectRatio: 1,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: media.length,
                itemBuilder: (context, index) {
                  final url = media[index].thumbnailUrl;
                  if (url.isEmpty) return _placeholder();
                  return CachedNetworkImage(
                    imageUrl: url,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    errorWidget: (_, _, _) => _placeholder(),
                  );
                },
              ),
            ),
          ),
          if (media.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(media.length, (i) {
                  final active = i == widget.currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: active ? 12 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholder() => Container(
    height: 160,
    width: double.infinity,
    color: const Color.fromARGB(255, 216, 217, 219),
    child: const Icon(
      Icons.image_not_supported_outlined,
      color: AppColors.textLightGrey,
      size: 32,
    ),
  );
}
