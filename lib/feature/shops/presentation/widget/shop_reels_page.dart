import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/reels/bloc/reels_bloc.dart';
import 'package:mbium_mobile_client/feature/reels/data/reels_repository.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_filter_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';
import 'package:mbium_mobile_client/feature/reels/presentation/shop_reels_screen.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

/// "Reels" tab of the shop detail screen — a grid of thumbnail tiles.
/// Tapping one opens the same TikTok-style vertical feed used elsewhere
/// ([ShopReelsScreen]), starting on the tapped reel.
class ShopReelsPage extends StatelessWidget {
  const ShopReelsPage({super.key, required this.model});

  final ShopDetailModel model;

  @override
  Widget build(BuildContext context) {
    final shopId = model.id ?? 0;
    final shop = ReelShop(id: shopId, name: model.localizedName, logo: model.logo);

    return BlocProvider(
      create: (context) => ReelsBloc(repository: context.read<ReelsRepository>())
        ..add(LoadReels(ReelsFilterModel(shopId: shopId))),
      child: _ShopReelsGrid(shop: shop),
    );
  }
}

class _ShopReelsGrid extends StatelessWidget {
  const _ShopReelsGrid({required this.shop});

  final ReelShop shop;

  void _openReel(BuildContext context, int reelId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShopReelsScreen(shop: shop, initialReelId: reelId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelsBloc, ReelsState>(
      builder: (context, state) {
        if (state is ReelsLoading || state is ReelsInitial) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen));
        }

        if (state is ReelsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.lightTextSecondary, fontSize: 13),
              ),
            ),
          );
        }

        if (state is! ReelsLoaded || state.reels.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Reels tapylmady',
                style: TextStyle(color: AppColors.lightTextSecondary, fontSize: 13),
              ),
            ),
          );
        }

        final reels = state.reels;

        return GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 9 / 16,
          ),
          itemCount: reels.length,
          itemBuilder: (context, index) {
            final reel = reels[index];
            return _ReelThumbTile(reel: reel, onTap: () => _openReel(context, reel.id));
          },
        );
      },
    );
  }
}

class _ReelThumbTile extends StatelessWidget {
  const _ReelThumbTile({required this.reel, required this.onTap});

  final ReelsModel reel;
  final VoidCallback onTap;

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '$count';
  }

  @override
  Widget build(BuildContext context) {
    final thumbnailUrl = reel.thumbnail?.thumbnailUrl;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: AppColors.navBarGrey),
          if (thumbnailUrl != null && thumbnailUrl.isNotEmpty)
            CachedNetworkImage(
              imageUrl: thumbnailUrl,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textLightGrey,
              ),
            )
          else
            const Center(
              child: Icon(Icons.movie_outlined, color: AppColors.textLightGrey, size: 28),
            ),
          const Positioned(
            top: 6,
            right: 6,
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 20,
              shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
            ),
          ),
          Positioned(
            left: 6,
            bottom: 6,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  color: Colors.white,
                  size: 13,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                ),
                const SizedBox(width: 3),
                Text(
                  _formatCount(reel.viewCount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
