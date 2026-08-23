import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailQuickLinksWidget extends StatelessWidget {
  final String? categoryName;
  final VoidCallback? onCategoryTap;
  final String? shopName;
  final VoidCallback? onShopTap;

  const ProductDetailQuickLinksWidget({
    super.key,
    this.categoryName,
    this.onCategoryTap,
    this.shopName,
    this.onShopTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    if (categoryName == null && shopName == null) return const SizedBox.shrink();

    return Row(
      children: [
        if (categoryName != null)
          Expanded(
            child: _QuickLinkBox(
              icon: Icons.folder_outlined,
              title: categoryName!,
              label: l10n.category,
              onTap: onCategoryTap,
            ),
          ),
        if (categoryName != null && shopName != null) const SizedBox(width: 10),
        if (shopName != null)
          Expanded(
            child: _QuickLinkBox(
              icon: Icons.storefront_outlined,
              title: shopName!,
              label: l10n.onduriji,
              onTap: onShopTap,
            ),
          ),
      ],
    );
  }
}

class _QuickLinkBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String label;
  final VoidCallback? onTap;

  const _QuickLinkBox({
    required this.icon,
    required this.title,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.navBarGrey),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.lightTextSecondary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textStyles.s13w600clBlack,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}