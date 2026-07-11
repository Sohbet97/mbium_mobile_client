import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:share_plus/share_plus.dart';

class ShopDetailAppBarWidget extends StatelessWidget {
  final ShopDetailModel model;
  final bool isCollapsed;

  const ShopDetailAppBarWidget({
    super.key,
    required this.model,
    required this.isCollapsed,
  });

void _share() {
  // Bellik: häzirlikçe diňe dükanyň adyny paýlaşýar.
  Share.share(model.localizedName);
}

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isCollapsed
            ? Row(
                key: const ValueKey('collapsed'),
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.lightTextPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      model.localizedName,
                      style: textStyles.s16w600clBlack,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border,
                        color: AppColors.lightTextPrimary),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.ios_share_outlined,
                        color: AppColors.lightTextPrimary),
                    onPressed: _share,
                  ),
                ],
              )
            : Row(
                key: const ValueKey('expanded'),
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.navBarGrey),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              color: AppColors.lightTextSecondary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              model.localizedName,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.lightTextSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.camera_alt_outlined,
                              color: AppColors.lightTextSecondary, size: 20),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: AppColors.lightTextPrimary),
                    onPressed: () {
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.ios_share_outlined,
                        color: AppColors.lightTextPrimary),
                    onPressed: _share,
                  ),
                ],
              ),
      ),
    );
  }
}