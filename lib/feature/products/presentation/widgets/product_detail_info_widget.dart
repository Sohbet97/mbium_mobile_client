import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/extensions/product_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

class ProductDetailInfoWidget extends StatelessWidget {
  final ProductModel product;

  const ProductDetailInfoWidget({super.key, required this.product});

  AppLanguage _getLanguage(String code) {
    switch (code) {
      case 'ru': return AppLanguage.ru;
      case 'en': return AppLanguage.en;
      default: return AppLanguage.tk;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final languageCode = context.read<MainBloc>().state.languageCode;
    final lang = _getLanguage(languageCode);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product.nameByLang(lang),
                  style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.bonusBannerGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Täze',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.bonusBannerTextGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star,
                      color: AppColors.starYellow, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
              const Text('|',
                  style: TextStyle(color: AppColors.navBarGrey)),
              Text(
                'Stokda bar: ${product.stock}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              const Text('|',
                  style: TextStyle(color: AppColors.navBarGrey)),
              Text(
                'SKU: ${product.sku}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product.price.toStringAsFixed(2)} ${product.currency}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
              if (product.compareAtPrice != null &&
                  product.compareAtPrice! > product.price) ...[
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    '${product.compareAtPrice!.toStringAsFixed(2)} ${product.currency}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLightGrey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}