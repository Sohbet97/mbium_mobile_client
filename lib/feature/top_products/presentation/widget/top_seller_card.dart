import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

class TopSellerCard extends StatelessWidget {
  final ShopModel shopModel;
  const TopSellerCard({super.key, required this.shopModel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color color = switch (shopModel.order) {
      1 => AppColors.topFirst,
      2 => AppColors.topSecond,
      3 => AppColors.topThird,
      _ => AppColors.primaryGreen,
    };
    final icon = switch (shopModel.order) {
      1 => SvgIcon(iconName: 'assets/icons/top.svg', color: AppColors.topFirst),
      2 => Text('🥈'),
      3 => Text('🥉'),
      _ => Icon(Icons.arrow_downward_outlined, color: Colors.grey, size: 18),
    };
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.2),
      ),
      child: Row(
        children: [
          _cell(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                Text(
                  shopModel.order.toString(),
                  style: theme.textTheme.labelSmall,
                ),
              ],
            ),
          ),

          _cell(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //        CircleAvatar(),
                //      SizedBox(width: 8),
                Text(
                  shopModel.name!,

                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          _cell(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgIcon(
                  iconName: 'assets/icons/top_chat.svg',
                  height: 16,
                  width: 16,
                  color: color,
                ),
                Text(
                  "1000",

                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _cell(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgIcon(
                  iconName: 'assets/icons/top_rating_star.svg',
                  height: 16,
                  width: 16,
                  color: color,
                ),
                Text(
                  shopModel.rating.toString(),

                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _cell(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgIcon(
                  iconName: 'assets/icons/shopping_basket.svg',
                  height: 16,
                  width: 16,
                  color: color,
                ),
                Text(
                  "1200",

                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _cell(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgIcon(
                  iconName: 'assets/icons/top_speed.svg',
                  height: 16,
                  width: 16,
                  color: color,
                ),
                Text(
                  "1000",
                  textAlign: TextAlign.center,

                  style: theme.textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _cell(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_rounded, color: color, size: 18),
                Text(
                  "750",

                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _cell(
            hasRightBorder: false,
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '9.7',
                  style: theme.textTheme.labelSmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cell({
    required Widget child,
    int flex = 1,
    bool hasRightBorder = true,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        height: double.infinity,
        //    margin: EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          border: hasRightBorder
              ? const Border(right: BorderSide(color: Colors.grey, width: 1))
              : null,
        ),
        child: Center(child: child),
      ),
    );
  }
}
