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
      height: 30,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: deliveryTypes.length == 1
          ? SizedBox(
              width: double.infinity,
              child: Container(
                color: AppColors.primaryGreen.withOpacity(0.2),
                height: 30,
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(Icons.delivery_dining_outlined),
                    const SizedBox(width: 4),
                    Text(
                      _nameByLang(deliveryTypes[0]),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.aiTextBlack,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: deliveryTypes.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bonusBannerGreen,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.bonusBannerBorderGreen.withValues(
                        alpha: 0.4,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 12,
                        color: AppColors.bonusBannerTextGreen,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _nameByLang(deliveryTypes[index]),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.aiTextBlack,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
