import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/shop_favorite_item.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:share_plus/share_plus.dart';

class ShopDetailAppBarWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailAppBarWidget({super.key, required this.model});

  void _share() {
    Share.share(model.localizedName);
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              model.localizedName,
              style: textStyles.s16w600clBlack,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ShopFavoriteItemWidget(shop: model),
          IconButton(
            icon: const Icon(Icons.ios_share_outlined, color: AppColors.lightTextPrimary),
            onPressed: _share,
          ),
        ],
      ),
    );
  }
}