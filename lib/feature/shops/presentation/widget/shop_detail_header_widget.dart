import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/shop_favorite_item.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';

class ShopDetailHeaderWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailHeaderWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 186,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    image: model.logo != null && model.logo!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(model.logo!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                ),
              ),
              Positioned(
                left: 16,
                top: 106,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.navWhite,
                    borderRadius: BorderRadius.circular(16),
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
                              size: 30,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.store_outlined,
                          color: AppColors.primaryGreen,
                          size: 30,
                        ),
                ),
              ),
              Positioned(
                right: 16,
                top: 150,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ShopFavoriteItemWidget(shop: model),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      model.localizedName,
                      style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (model.isVerified == true) ...[
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified,
                      color: AppColors.bonusBannerTextGreen,
                      size: 18,
                    ),
                  ],
                ],
              ),
              if (model.type?.name != null) ...[
                const SizedBox(height: 4),
                Text(
                  model.type!.name!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (model.rating != null) ...[
                          const Icon(
                            Icons.star,
                            color: AppColors.starYellow,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${model.rating}/5',
                            style: textStyles.s13w600clBlack,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '·',
                            style: TextStyle(
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        if (model.address != null && model.address!.isNotEmpty)
                          Text(
                            model.address!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline, size: 15),
                    label: const Text('Habarlaş'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: const BorderSide(color: AppColors.primaryGreen),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
