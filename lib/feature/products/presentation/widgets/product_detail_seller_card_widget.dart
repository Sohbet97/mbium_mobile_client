import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

/// Alibaba-style seller-trust strip: shop avatar, name and a "go to shop"
/// affordance.
class ProductDetailSellerCardWidget extends StatelessWidget {
  const ProductDetailSellerCardWidget({
    super.key,
    required this.shopId,
    required this.shop,
  });

  final int shopId;
  final ProductDetailShop? shop;

  @override
  Widget build(BuildContext context) {
    if (shop == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.pushNamed(
            context,
            '/shopDetail',
            arguments: ShopModel(id: shopId, name: shop!.name),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withValues(alpha: 0.06),
                  Colors.white,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _ShopAvatar(name: shop!.name, logoUrl: shop!.logo),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop!.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Satyjy',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.lightTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Dükana git',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.navWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 3),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11,
                        color: AppColors.navWhite,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShopAvatar extends StatelessWidget {
  const _ShopAvatar({required this.name, this.logoUrl});

  final String name;
  final String? logoUrl;

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (logoUrl != null && logoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(logoUrl!),
        onBackgroundImageError: (_, _) {},
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
      child: Text(
        _initials,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
