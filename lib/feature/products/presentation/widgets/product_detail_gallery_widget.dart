import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_images_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_full_screen_images.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

const int _maxGalleryTiles = 6;

/// Compact "more photos" grid shown further down the product page — the
/// hero carousel up top already covers browsing; this is for a quick
/// at-a-glance preview with a way into the same full-screen viewer.
class ProductDetailGalleryWidget extends StatelessWidget {
  final List<ProductMedia> media;

  const ProductDetailGalleryWidget({super.key, required this.media});

  void _openFullScreen(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFullScreenImages(media: media, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return const SizedBox.shrink();

    final l10n = S.of(context);
    final textStyles = context.appTextStyles;
    final tileCount = media.length > _maxGalleryTiles ? _maxGalleryTiles : media.length;
    final remaining = media.length - _maxGalleryTiles;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_library_outlined, size: 18, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text('Suratlar (${media.length})', style: textStyles.s13w600clBlack),
              const Spacer(),
              GestureDetector(
                onTap: () => _openFullScreen(context, 0),
                child: Row(
                  children: [
                    Text(
                      l10n.hemmesini_gorkez,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primaryGreen),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tileCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final item = media[index];
              final isLastTile = index == tileCount - 1;
              final overflowCount = isLastTile && remaining > 0 ? remaining : 0;

              return GestureDetector(
                onTap: () => _openFullScreen(context, index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductNetworkImage(url: item.thumbnailUrl),
                      if (item.media.type == 'video')
                        Container(
                          color: Colors.black.withValues(alpha: 0.25),
                          child: const Icon(
                            Icons.play_circle_outline,
                            color: AppColors.navWhite,
                            size: 26,
                          ),
                        ),
                      if (overflowCount > 0)
                        Container(
                          color: Colors.black.withValues(alpha: 0.5),
                          alignment: Alignment.center,
                          child: Text(
                            '+$overflowCount',
                            style: const TextStyle(
                              color: AppColors.navWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
