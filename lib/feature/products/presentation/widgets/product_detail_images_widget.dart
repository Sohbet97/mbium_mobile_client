import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductDetailImagesWidget extends StatefulWidget {
  final ProductModel product;

  const ProductDetailImagesWidget({super.key, required this.product});

  @override
  State<ProductDetailImagesWidget> createState() =>
      _ProductDetailImagesWidgetState();
}

class _ProductDetailImagesWidgetState
    extends State<ProductDetailImagesWidget> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  List<String> get _imageUrls {
    return widget.product.productMedia
        .whereType<Map>()
        .where((m) => m['url'] != null)
        .map((m) => m['url'].toString())
        .toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = _imageUrls;

    if (urls.isEmpty) {
      return Container(
        height: 300,
        color: Theme.of(context).colorScheme.surface,
        child: const Center(
          child: Icon(Icons.image_not_supported_outlined,
              color: AppColors.textLightGrey, size: 60),
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: urls.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, i) {
              return Image.network(
                urls[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: AppColors.textLightGrey, size: 60),
                ),
              );
            },
          ),
        ),
        if (urls.length > 1)
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(urls.length, (i) {
                return Container(
                  width: i == _currentIndex ? 16 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _currentIndex
                        ? AppColors.primaryGreen
                        : AppColors.navWhite,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}