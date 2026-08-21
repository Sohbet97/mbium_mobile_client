import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

/// Alibaba-style floating circular icon buttons (back / favorite / share)
/// replacing the plain [AppBar] actions row.
class ProductDetailTopBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const ProductDetailTopBarWidget({
    super.key,
    required this.product,
    required this.onShare,
  });

  final ProductModel product;
  final VoidCallback onShare;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: _CircleIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).pop(),
      ),
      actions: [
        _CircleIconButton(
          child: FavoriteItemWidget(product: product, size: 18),
        ),
        const SizedBox(width: 4),
        _CircleIconButton(icon: Icons.share_outlined, onTap: onShare),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({this.icon, this.onTap, this.child})
      : assert(icon != null || child != null);

  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: child ?? Icon(icon, size: 18, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
