import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/favorite_bloc.dart';
import 'package:mbium_mobile_client/feature/products/bloc/recently/recently_viewed_bloc.dart';
import 'package:mbium_mobile_client/feature/products/extensions/product_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_images_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_info_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_shop_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_features_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  AppLanguage _getLanguage(String code) {
    switch (code) {
      case 'ru': return AppLanguage.ru;
      case 'en': return AppLanguage.en;
      default: return AppLanguage.tk;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<RecentlyViewedBloc>().add(AddRecentlyViewed(widget.product));
  }

  void _showQuantityBottomSheet(BuildContext context) {
    int quantity = 1;
    final textStyles = context.appTextStyles;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.navBarGrey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Mukdary saýlaň', style: textStyles.s16w600clBlack),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: quantity > 1
                              ? () => setModalState(() => quantity--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: AppColors.primaryGreen,
                          iconSize: 32,
                        ),
                        const SizedBox(width: 24),
                        Text('$quantity',
                            style: textStyles.s16w600clBlack
                                .copyWith(fontSize: 22)),
                        const SizedBox(width: 24),
                        IconButton(
                          onPressed: quantity < widget.product.stock
                              ? () => setModalState(() => quantity++)
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                          color: AppColors.primaryGreen,
                          iconSize: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Jemi: ${(widget.product.price * quantity).toStringAsFixed(2)} ${widget.product.currency}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          for (int i = 0; i < quantity; i++) {
                            context
                                .read<CartBloc>()
                                .add(AddToCartEvent(widget.product));
                          }
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Sebede goşuldy ($quantity sany)'),
                              backgroundColor: AppColors.primaryGreen,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.navWhite,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Sebede goş',
                            style: textStyles.s16w600clBlack
                                .copyWith(color: AppColors.navWhite)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final languageCode = context.read<MainBloc>().state.languageCode;
    final lang = _getLanguage(languageCode);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.nameByLang(lang),
          style: textStyles.s13w600clBlack,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              final isFav = state is FavoriteLoaded &&
                  state.favorites.any((p) => p.id == widget.product.id);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav
                      ? AppColors.errorRed
                      : AppColors.lightTextSecondary,
                ),
                onPressed: () {
                  context
                      .read<FavoriteBloc>()
                      .add(ToggleFavoriteProduct(widget.product));
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: AppColors.lightTextSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductDetailImagesWidget(product: widget.product),
            const SizedBox(height: 8),

            ProductDetailInfoWidget(product: widget.product),
            const SizedBox(height: 8),

            ProductDetailShopWidget(
              product: widget.product,
              onTap: () {},
            ),
            const SizedBox(height: 8),

            ProductDetailFeaturesWidget(product: widget.product),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat_bubble_outline,
                        color: AppColors.primaryGreen, size: 18),
                    const SizedBox(width: 6),
                    Text('Teswirler',
                        style: textStyles.s13w600clBlack.copyWith(
                            color: AppColors.primaryGreen)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => _showQuantityBottomSheet(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.navWhite,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Sebede goş',
                    style: textStyles.s16w600clBlack
                        .copyWith(color: AppColors.navWhite)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}