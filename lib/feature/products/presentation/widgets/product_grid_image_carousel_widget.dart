import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';

class ProductGridImageCarouselWidget extends StatelessWidget {
  final List<ProductMedia> media;
  final int currentIndex;

  const ProductGridImageCarouselWidget({
    super.key,
    required this.media,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (media.isEmpty) return _placeholder();

    final index = currentIndex.clamp(0, media.length - 1);
    final url = media[index].thumbnailUrl;

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: url.isEmpty
                ? _placeholder()
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Image.network(
                      url,
                      key: ValueKey(url),
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                      errorBuilder: (_, __, ___) => _placeholder(),
                    ),
                  ),
          ),
          if (media.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(media.length, (i) {
                  final active = i == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: active ? 12 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: active ? Colors.white : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 2),
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
        child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textLightGrey, size: 32),
      );
}