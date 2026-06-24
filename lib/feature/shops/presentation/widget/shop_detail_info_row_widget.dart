import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopDetailInfoRowWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailInfoRowWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              context,
              icon: Icons.star,
              iconColor: AppColors.starYellow,
              title: 'Baha',
              value: model.rating != null
                  ? '${model.rating} / 5.0'
                  : '0 / 5.0',
            ),
          ),
          _buildDivider(),

          Expanded(
            child: _buildInfoItem(
              context,
              icon: Icons.location_on_outlined,
              iconColor: AppColors.lightTextSecondary,
              title: 'Ýeri',
              value: model.address ?? '-',
            ),
          ),
          _buildDivider(),

          Expanded(
            child: _buildInfoItem(
              context,
              icon: Icons.store_outlined,
              iconColor: AppColors.lightTextSecondary,
              title: 'Dükanyň görnüşi',
              value: model.type?.name ?? '-',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    final textStyles = context.appTextStyles;
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: textStyles.s13w600clBlack.copyWith(fontSize: 12),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.navBarGrey,
    );
  }
}