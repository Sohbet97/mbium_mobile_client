import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/page/cart_page.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comments_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_features_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_images_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_info_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_shop_card_widget.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../generated/l10n.dart';
import '../extensions/product_extensions.dart';

class ProductDetailDataScreen extends StatelessWidget {
  const ProductDetailDataScreen({
    super.key,
    required this.model,
    required this.litleProductModel,
  });

  final ProductDetailModel model;
  final ProductModel litleProductModel;

  void _share(AppLanguage lang) {
    final name = model.nameByLang(lang);
    final price = '${model.price.toStringAsFixed(2)} ${model.currency}';
    final url = 'https://mbium.com/products/${model.id}';
    Share.share('$name\n$price\n$url');
  }

  void _openShop(BuildContext context) {
    if (model.shop == null) return;
    final shopModel = ShopModel(
      id: model.shopId,
      name: model.shop!.name,
      logo: model.shop!.logo,
    );
    Navigator.pushNamed(context, '/shopDetail', arguments: shopModel);
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final lang = AppLanguage.fromCode(context.read<MainBloc>().state.languageCode);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          model.nameByLang(lang),
          style: context.appTextStyles.s13w600clBlack,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          FavoriteItemWidget(product: litleProductModel, size: 22),
          IconButton(
            onPressed: () => _share(lang),
            icon: const Icon(
              Icons.share_outlined,
              color: AppColors.lightTextSecondary,
              size: 22,
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        model: model,
        product: litleProductModel,
        localization: localization,
        onOpenShop: () => _openShop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ProductDetailImagesWidget(product: model),
            const SizedBox(height: 8),
            ProductDetailInfoWidget(product: model),
            const SizedBox(height: 8),
            ProductDetailFeaturesWidget(product: model),
            if (model.shop != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ProductDetailShopCardWidget(
                  shop: model.shop!,
                  onOpenShop: () => _openShop(context),
                  onMessage: () {
                    // 
                  },
                ),
              ),
            ],
            const SizedBox(height: 8),
            ProductDetailCommentsWidget(
            productId: model.id,
            rating: model.rating,
            reviewCount: model.reviewCount,
          ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}



class _BottomBar extends StatelessWidget {
  final ProductDetailModel model;
  final ProductModel product;
  final S localization;
  final VoidCallback onOpenShop;

  const _BottomBar({
    required this.model,
    required this.product,
    required this.localization,
    required this.onOpenShop,
  });

  @override
  Widget build(BuildContext context) {
    final qty = context.select<CartBloc, int>((bloc) {
      final s = bloc.state;
      return s is CartLoaded ? s.quantityOf(product.id) : 0;
    });

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              _ShopButton(onTap: model.shop != null ? onOpenShop : null),
              const SizedBox(width: 12),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(
                      scale: Tween(begin: 0.92, end: 1.0).animate(anim),
                      child: child,
                    ),
                  ),
                  child: qty == 0
                      ? _AddButton(
                          key: const ValueKey('add'),
                          price: model.price,
                          currency: model.currency,
                          outOfStock: model.stock == 0 && !model.sellWhenOutOfStock,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.read<CartBloc>().add(AddToCartEvent(product));
                          },
                        )
                      : _StepperButton(
                          key: const ValueKey('stepper'),
                          quantity: qty,
                          price: model.price,
                          currency: model.currency,
                          onDecrement: () {
                            HapticFeedback.lightImpact();
                            context.read<CartBloc>().add(
                                UpdateQuantityEvent(product.id, qty - 1));
                          },
                          onIncrement: () {
                            HapticFeedback.lightImpact();
                            context.read<CartBloc>().add(
                                UpdateQuantityEvent(product.id, qty + 1));
                          },
                        ),
                ),
              ),
              if (qty > 0) ...[
                const SizedBox(width: 10),
                _CartPageButton(
                  onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (_) => DraggableScrollableSheet(
                      initialChildSize: 0.6,
                      minChildSize: 0.4,
                      maxChildSize: 0.93,
                      expand: false,
                      builder: (_, scrollController) => ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Scaffold(
                          body: CustomScrollView(
                            controller: scrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 4),
                                    child: Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: AppColors.navBarGrey,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: SafeArea(child: CartPage()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ShopButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ShopButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.navBarGrey, width: 1.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.storefront_outlined, color: AppColors.primaryGreen, size: 24),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final double price;
  final String currency;
  final bool outOfStock;
  final VoidCallback onTap;

  const _AddButton({
    super.key,
    required this.price,
    required this.currency,
    required this.outOfStock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, color: AppColors.navWhite, size: 18),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).sebede_gos,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navWhite,
                  ),
                ),
                if (!outOfStock)
                  Text(
                    '${price.toStringAsFixed(2)} $currency',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.navWhite.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final int quantity;
  final double price;
  final String currency;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _StepperButton({
    super.key,
    required this.quantity,
    required this.price,
    required this.currency,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final total = price * quantity;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _StepBtn(icon: Icons.remove, onTap: onDecrement),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: Text(
                    '$quantity sany',
                    key: ValueKey(quantity),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navWhite,
                    ),
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(2)} $currency',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.navWhite.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _StepBtn(icon: Icons.add, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.white24,
        child: SizedBox(width: 48, height: 52, child: Icon(icon, color: AppColors.navWhite, size: 20)),
      ),
    );
  }
}

class _CartPageButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CartPageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3), width: 1.5),
        ),
        child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryGreen, size: 22),
      ),
    );
  }
}