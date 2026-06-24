import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopDetailDetailsWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailDetailsWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    final items = [
      if (model.address != null && model.address!.isNotEmpty)
        _DetailItem(
            icon: Icons.location_on_outlined,
            label: 'Ýeri',
            value: model.address!),
      if (model.phone != null && model.phone!.isNotEmpty)
        _DetailItem(
            icon: Icons.phone_outlined,
            label: 'Habarlaşmak',
            value: model.phone!),
      if (model.email != null && model.email!.isNotEmpty)
        _DetailItem(
            icon: Icons.email_outlined,
            label: 'E-poçta',
            value: model.email!),
      if (model.type?.name != null)
        _DetailItem(
            icon: Icons.store_outlined,
            label: 'Dükanyň görnüşi',
            value: model.type!.name!),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dükan maglumatlary', style: textStyles.s13w600clBlack),
          const SizedBox(height: 14),
          ...items.asMap().entries.map((e) {
            final item = e.value;
            final isLast = e.key == items.length - 1;
            return Column(
              children: [
                Row(
                  children: [
                    Icon(item.icon,
                        color: AppColors.lightTextSecondary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.lightTextSecondary,
                            ),
                          ),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.lightTextPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!isLast) ...[
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;

  const _DetailItem(
      {required this.icon, required this.label, required this.value});
}