import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/extensions/product_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';

/// Alibaba-style shipping-options strip built from [DeliveryType]s that are
/// parsed off the API today but were never rendered in the detail screen.
class ProductDetailDeliveryWidget extends StatelessWidget {
  const ProductDetailDeliveryWidget({
    super.key,
    required this.deliveryTypes,
    required this.lang,
  });

  final List<DeliveryType> deliveryTypes;
  final AppLanguage lang;

  String _nameByLang(DeliveryType type) {
    switch (lang) {
      case AppLanguage.ru:
        return type.nameRu.isNotEmpty ? type.nameRu : type.name;
      case AppLanguage.en:
        return type.nameEn.isNotEmpty ? type.nameEn : type.name;
      case AppLanguage.tk:
        return type.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (deliveryTypes.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: deliveryTypes
            .where((t) => t.isActive)
            .map(
              (t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColors.bonusBannerGreen,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.bonusBannerBorderGreen.withValues(alpha: 0.4),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      size: 15,
                      color: AppColors.bonusBannerTextGreen,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _nameByLang(t),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.aiTextBlack,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
