import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopDetailHeaderWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailHeaderWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            image: model.logo != null && model.logo!.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(model.logo!),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  )
                : null,
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.navWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.navWhite.withValues(alpha: 0.5),
                      width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: model.logo != null && model.logo!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          model.logo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.store_outlined,
                            color: AppColors.primaryGreen,
                            size: 36,
                          ),
                        ),
                      )
                    : const Icon(Icons.store_outlined,
                        color: AppColors.primaryGreen, size: 36),
              ),
              const SizedBox(height: 10),

              Text(
                model.localizedName,
                style: textStyles.s16w600clBlack.copyWith(
                  color: AppColors.navWhite,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),

              if (model.type?.name != null)
                Text(
                  model.type!.name!,
                  style: const TextStyle(
                    color: AppColors.navWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              const SizedBox(height: 6),

              Row(
                children: [
                  if (model.rating != null) ...[
                    const Icon(Icons.star,
                        color: AppColors.starYellow, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      model.rating!,
                      style: const TextStyle(
                        color: AppColors.navWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (model.isVerified == true) ...[
                    const Icon(Icons.verified,
                        color: AppColors.bonusBannerTextGreen, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Verified',
                      style: TextStyle(
                        color: AppColors.bonusBannerTextGreen,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}