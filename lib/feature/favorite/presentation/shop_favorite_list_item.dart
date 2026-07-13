import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/shop_favorite_item.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

class ShopFavoriteListItem extends StatelessWidget {
  const ShopFavoriteListItem({super.key, required this.shop});

  final ShopDetailModel shop;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/shopDetail',
        arguments: ShopModel(id: shop.id),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: shop.logo != null && shop.logo!.isNotEmpty
                  ? Image.network(
                      shop.logo!,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _PlaceholderLogo(),
                    )
                  : _PlaceholderLogo(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.localizedName,
                    style: textStyles.s13w600clBlack,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (shop.address != null && shop.address!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      shop.address!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            ShopFavoriteItemWidget(shop: shop, size: 20),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      color: AppColors.primaryGreen,
      child: const Icon(Icons.store_outlined, color: Colors.white),
    );
  }
}
