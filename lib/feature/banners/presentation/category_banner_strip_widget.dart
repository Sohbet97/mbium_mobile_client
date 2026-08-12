import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/model/banner_model.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/banner_slide_widget.dart';

const _bannersPerStrip = 5;

/// Horizontal scroll strip of up to [_bannersPerStrip] active `category`
/// banners, picked starting at [insertionIndex] * 5 and wrapping via modulo —
/// used both as the static row right after the subcategory grid and,
/// repeated with an increasing [insertionIndex], before every page of
/// products loaded further down.
class CategoryBannerStripWidget extends StatelessWidget {
  final int insertionIndex;

  const CategoryBannerStripWidget({super.key, required this.insertionIndex});

  @override
  Widget build(BuildContext context) {
    final bannerState = context.watch<BannerBloc>().state;
    final allBanners = bannerState is BannerLoaded
        ? bannerState
              .bannersByType('category')
              .where((b) => b.isCurrentlyActive)
              .toList()
        : const <BannerModel>[];

    if (allBanners.isEmpty) return const SizedBox.shrink();

    final slideCount = allBanners.length < _bannersPerStrip
        ? allBanners.length
        : _bannersPerStrip;
    final banners = List.generate(
      slideCount,
      (i) =>
          allBanners[(insertionIndex * _bannersPerStrip + i) %
              allBanners.length],
    );

    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: banners.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) => SizedBox(
          width: 160,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: BannerSlideWidget(banner: banners[index], compact: true),
          ),
        ),
      ),
    );
  }
}
