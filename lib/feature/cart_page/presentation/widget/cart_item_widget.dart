import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/cart_page/models/cart_model.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.cartModel});
  final CartModel cartModel;

  String get _imageUrl {
    return cartModel.product.primaryThumbnailUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final product = cartModel.product;
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(product.id),
      direction: DismissDirection.endToStart,
      background: _buildDismissBackground(),
      onDismissed: (_) =>
          context.read<CartBloc>().add(RemoveFromCartEvent(product.id)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildDeleteButton(context, product.id),
                      ],
                    ),
                    if (product.category != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.category!.name,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildPrice(context, product),
                        _buildQuantityControl(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      ),
      child: _imageUrl.isNotEmpty
          ? Image.network(
              _imageUrl,
              width: 90,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imagePlaceholder(),
            )
          : _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 90,
      height: 110,
      color: AppColors.navBarGrey,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textLightGrey,
        size: 28,
      ),
    );
  }

  Widget _buildPrice(BuildContext context, product) {
    final hasDiscount =
        cartModel.product.compareAtPrice != null &&
        cartModel.product.compareAtPrice! > cartModel.product.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${cartModel.product.price.toStringAsFixed(2)} ${cartModel.product.currency}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreen,
          ),
        ),
        if (hasDiscount)
          Text(
            '${cartModel.product.compareAtPrice!.toStringAsFixed(2)} ${cartModel.product.currency}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textLightGrey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _buildQuantityControl(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove,
            onTap: () {
              if (cartModel.quantity > 1) {
                context.read<CartBloc>().add(
                  UpdateQuantityEvent(
                    cartModel.product.id,
                    cartModel.quantity - 1,
                  ),
                );
              } else {
                context.read<CartBloc>().add(
                  RemoveFromCartEvent(cartModel.product.id),
                );
              }
            },
          ),
          SizedBox(
            width: 28,
            child: Text(
              '${cartModel.quantity}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add,
            onTap: () => context.read<CartBloc>().add(
              UpdateQuantityEvent(cartModel.product.id, cartModel.quantity + 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context, int productId) {
    return GestureDetector(
      onTap: () => context.read<CartBloc>().add(RemoveFromCartEvent(productId)),
      child: const Padding(
        padding: EdgeInsets.only(left: 8),
        child: Icon(
          Icons.close_rounded,
          size: 18,
          color: AppColors.textLightGrey,
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.errorRed,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      child: const Icon(Icons.delete_outline, color: Colors.white, size: 26),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: AppColors.primaryGreen,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
