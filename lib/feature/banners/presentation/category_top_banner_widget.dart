import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/model/banner_model.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/banner_slide_widget.dart';

/// Single `category` banner shown above the subcategory grid. Picked via
/// `banners[categoryId % banners.length]` — deterministic per category, so
/// switching the selected category shows a different banner whenever more
/// than one is active (there's no real category↔banner link in the API, so
/// this is a stand-in rotation rather than a targeted match).
class CategoryTopBannerWidget extends StatelessWidget {
  final int categoryId;

  const CategoryTopBannerWidget({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final bannerState = context.watch<BannerBloc>().state;
    final banners = bannerState is BannerLoaded
        ? bannerState
              .bannersByType('category')
              .where((b) => b.isCurrentlyActive)
              .toList()
        : const <BannerModel>[];

    if (banners.isEmpty) return const SizedBox.shrink();

    final banner = banners[categoryId % banners.length];

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        key: ValueKey(banner.id),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 16 / 7,
          child: BannerSlideWidget(banner: banner, compact: true),
        ),
      ),
    );
  }
}
