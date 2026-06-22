import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopDetailInfoWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailInfoWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final items = [
      if (model.phone != null && model.phone!.isNotEmpty)
        _InfoItem(icon: Icons.phone_outlined, value: model.phone!),
      if (model.email != null && model.email!.isNotEmpty)
        _InfoItem(icon: Icons.email_outlined, value: model.email!),
      if (model.address != null && model.address!.isNotEmpty)
        _InfoItem(icon: Icons.location_on_outlined, value: model.address!),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(item.icon,
                        color: AppColors.primaryGreen, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (i < items.length - 1)
                const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String value;

  const _InfoItem({required this.icon, required this.value});
}