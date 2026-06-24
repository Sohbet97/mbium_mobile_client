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

class _ProductDetailImagesWidgetState extends State<ProductDetailImagesWidget> {
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

  Widget _buildImage(String? url, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (url == null || url.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: AppColors.navBarGrey,
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppColors.textLightGrey, size: 30),
      );
    }
    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: AppColors.navBarGrey,
        child: const Icon(Icons.image_not_supported_outlined,
            color: AppColors.textLightGrey, size: 30),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = _imageUrls;
    final visibleThumbs = urls.take(3).toList();
    final remaining = urls.length - 3;

    final thumbCount = visibleThumbs.isEmpty ? 4 : visibleThumbs.length + (remaining > 0 ? 1 : 0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            children: [
              if (visibleThumbs.isEmpty) ...[
                for (int i = 0; i < 3; i++)
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: i == 0 ? AppColors.navBarGrey.withValues(alpha: 0.6) : AppColors.navBarGrey,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: i == 0 ? AppColors.primaryGreen : AppColors.navBarGrey,
                        width: i == 0 ? 2 : 1,
                      ),
                    ),
                    child: const Icon(Icons.image_outlined,
                        color: AppColors.textLightGrey, size: 24),
                  ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.navBarGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('+3',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.lightTextPrimary)),
                  ),
                ),
              ] else ...[
                ...visibleThumbs.asMap().entries.map((e) {
                  final isSelected = _currentIndex == e.key;
                  return GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(e.key,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.navBarGrey,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: _buildImage(e.value, width: 60, height: 60),
                      ),
                    ),
                  );
                }),
                if (remaining > 0)
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.navBarGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('+$remaining',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.lightTextPrimary)),
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 280,
                    width: double.infinity,
                    child: urls.isEmpty
                        ? Container(
                            color: AppColors.navBarGrey,
                            child: const Center(
                              child: Icon(Icons.image_not_supported_outlined,
                                  color: AppColors.textLightGrey, size: 60),
                            ),
                          )
                        : PageView.builder(
                            controller: _pageController,
                            itemCount: urls.length,
                            onPageChanged: (i) =>
                                setState(() => _currentIndex = i),
                            itemBuilder: (context, i) {
                              return _buildImage(urls[i],
                                  width: double.infinity,
                                  height: 280,
                                  fit: BoxFit.contain);
                            },
                          ),
                  ),
                ),
                if (urls.length > 1)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_currentIndex + 1} / ${urls.length}',
                          style: const TextStyle(
                              color: AppColors.navWhite, fontSize: 12),
                        ),
                      ),
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