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
      case 'ru':
        return AppLanguage.ru;
      case 'en':
        return AppLanguage.en;
      default:
        return AppLanguage.tk;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final languageCode = context.read<MainBloc>().state.languageCode;
    final lang = _getLanguage(languageCode);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            product.nameByLang(lang),
            style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.star, color: AppColors.starYellow),
              const SizedBox(width: 4),
              Text(
                product.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${product.reviewCount})',
                style: const TextStyle(
                  fontSize: 13,
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
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
              if (product.compareAtPrice != null &&
                  product.compareAtPrice! > product.price) ...[
                const SizedBox(width: 10),
                Text(
                  '${product.compareAtPrice!.toStringAsFixed(2)} ${product.currency}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textLightGrey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: product.stock > 0
                      ? AppColors.bonusBannerGreen
                      : AppColors.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  product.stock > 0
                      ? 'Stokda bar: ${product.stock}'
                      : 'Stokda ýok',
                  style: TextStyle(
                    fontSize: 12,
                    color: product.stock > 0
                        ? AppColors.bonusBannerTextGreen
                        : AppColors.errorRed,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}