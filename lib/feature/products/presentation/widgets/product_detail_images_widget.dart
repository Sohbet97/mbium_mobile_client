import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/product_3d_view_screen.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_full_screen_images.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_spin_view_widget.dart';

class ProductDetailImagesWidget extends StatefulWidget {
  final ProductDetailModel product;
  final ProductModel littleProducts;
  const ProductDetailImagesWidget({
    super.key,
    required this.product,
    required this.littleProducts,
  });

  @override
  State<ProductDetailImagesWidget> createState() =>
      _ProductDetailImagesWidgetState();
}

class _ProductDetailImagesWidgetState extends State<ProductDetailImagesWidget> {
  int _currentIndex = 0;
  bool _is360Mode = false;
  final PageController _pageController = PageController();

  List<ProductMedia> get _displayMedia => widget.product.displayMedia;
  List<ProductMedia> get _spinMedia => widget.product.spinMedia;
  bool get _hasSpin => _spinMedia.isNotEmpty;
  String? get _model3dUrl => widget.product.model3dUrl;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openFullScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFullScreenImages(
          media: _displayMedia,
          initialIndex: _currentIndex,
        ),
      ),
    );
  }

  void _open3dView() {
    final url = _model3dUrl;
    if (url == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            Product3dViewScreen(modelUrl: url, title: widget.product.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Stack(
        children: [
          // Переключатель (spin) + кнопка 3D-просмотра

          // Контент
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _is360Mode
                ? ProductSpinViewWidget(
                    key: const ValueKey('spin'),
                    spinMedia: _spinMedia,
                    height: 280,
                  )
                : _PhotoView(
                    key: const ValueKey('photo'),
                    media: _displayMedia,
                    currentIndex: _currentIndex,
                    pageController: _pageController,
                    onPageChanged: (i) => setState(() => _currentIndex = i),
                    onOpenFullScreen: _openFullScreen,
                    product: widget.littleProducts,
                  ),
          ),
          if (_model3dUrl != null) ...[
            Positioned(
              right: 8,
              bottom: 8,
              child: _View3dChip(onTap: _open3dView),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

// ─── Mode toggle ──────────────────────────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  final bool is360;
  final ValueChanged<bool> onToggle;

  const _ModeToggle({required this.is360, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ToggleChip(
          label: 'Surat',
          icon: Icons.photo_outlined,
          selected: !is360,
          onTap: () => onToggle(false),
        ),
        const SizedBox(width: 8),
        _ToggleChip(
          label: '360°',
          icon: Icons.threesixty,
          selected: is360,
          onTap: () => onToggle(true),
        ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : AppColors.navBarGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected
                  ? AppColors.navWhite
                  : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.navWhite
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 3D view chip ─────────────────────────────────────────────────────────────

class _View3dChip extends StatelessWidget {
  final VoidCallback onTap;

  const _View3dChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.navBarGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.view_in_ar_outlined,
              size: 14,
              color: AppColors.lightTextSecondary,
            ),
            SizedBox(width: 4),
            Text(
              '3D',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Photo view (thumbnails + main image) ─────────────────────────────────────

class _PhotoView extends StatelessWidget {
  final List<ProductMedia> media;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onOpenFullScreen;
  final ProductModel product;
  const _PhotoView({
    super.key,
    required this.media,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.onOpenFullScreen,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 280,
          width: 60,
          child: media.isEmpty
              ? _EmptyThumbs()
              : SingleChildScrollView(
                  child: Column(
                    children: media.asMap().entries.map((e) {
                      return _ThumbItem(
                        media: e.value,
                        isSelected: currentIndex == e.key,
                        onTap: () => pageController.animateToPage(
                          e.key,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: media.isNotEmpty ? onOpenFullScreen : null,
            child: _MainMediaView(
              media: media,
              currentIndex: currentIndex,
              pageController: pageController,
              onPageChanged: onPageChanged,
              product: product,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Empty placeholders ───────────────────────────────────────────────────────

class _EmptyThumbs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (i) => Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.navBarGrey,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: i == 0 ? AppColors.primaryGreen : AppColors.navBarGrey,
              width: i == 0 ? 2 : 1,
            ),
          ),
          child: const Icon(
            Icons.image_outlined,
            color: AppColors.textLightGrey,
            size: 24,
          ),
        ),
      ),
    );
  }
}

// ─── Thumbnail item ───────────────────────────────────────────────────────────

class _ThumbItem extends StatelessWidget {
  final ProductMedia media;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThumbItem({
    required this.media,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.navBarGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProductNetworkImage(
                url: media.thumbnailUrl,
                width: 60,
                height: 60,
              ),
              if (media.media.type == 'video')
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Icon(
                    Icons.play_circle_outline,
                    color: AppColors.navWhite,
                    size: 22,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Main media view ──────────────────────────────────────────────────────────

class _MainMediaView extends StatelessWidget {
  final List<ProductMedia> media;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final ProductModel product;
  const _MainMediaView({
    required this.media,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: Stack(
          children: [
            if (media.isEmpty)
              Container(
                color: AppColors.navBarGrey,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textLightGrey,
                    size: 60,
                  ),
                ),
              )
            else
              PageView.builder(
                controller: pageController,
                itemCount: media.length,
                onPageChanged: onPageChanged,
                itemBuilder: (_, i) {
                  final item = media[i];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductNetworkImage(
                        url: item.url,
                        width: double.infinity,
                        height: 280,
                        fit: BoxFit.cover,
                      ),
                      if (item.media.type == 'video')
                        const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: AppColors.navWhite,
                            size: 56,
                          ),
                        ),
                    ],
                  );
                },
              ),
            if (media.isNotEmpty)
              Positioned(
                top: 8,
                right: 8,
                child: FavoriteItemWidget(product: product),
              ),
            if (media.length > 1)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${currentIndex + 1} / ${media.length}',
                      style: const TextStyle(
                        color: AppColors.navWhite,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared network image ─────────────────────────────────────────────────────

class ProductNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color backgroundColor;

  const ProductNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.backgroundColor = AppColors.navBarGrey,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _placeholder();

    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => Container(
        width: width,
        height: height,
        color: backgroundColor,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primaryGreen,
          ),
        ),
      ),
      errorWidget: (_, _, _) => _placeholder(),
    );
  }

  Widget _placeholder() => Container(
    width: width,
    height: height,
    color: backgroundColor,
    child: const Icon(
      Icons.image_not_supported_outlined,
      color: AppColors.textLightGrey,
      size: 30,
    ),
  );
}
