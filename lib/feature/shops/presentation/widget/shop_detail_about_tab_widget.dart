import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopDetailAboutTabWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailAboutTabWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    final items = [
      if (model.address != null && model.address!.isNotEmpty)
        _AboutItem(
            icon: Icons.location_on_outlined,
            label: 'Ýeri',
            value: model.address!),
      if (model.phone != null && model.phone!.isNotEmpty)
        _AboutItem(
            icon: Icons.phone_outlined, label: 'Telefon', value: model.phone!),
      if (model.email != null && model.email!.isNotEmpty)
        _AboutItem(
            icon: Icons.email_outlined, label: 'E-poçta', value: model.email!),
      if (model.type?.name != null)
        _AboutItem(
            icon: Icons.category_outlined,
            label: 'Kategoriýa',
            value: model.type!.name!),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Column(
          children: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(item.icon,
                        color: AppColors.lightTextSecondary, size: 20),
                    const SizedBox(width: 14),
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
                          const SizedBox(height: 2),
                          Text(item.value, style: textStyles.s13w600clBlack),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.lightTextSecondary, size: 20),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
          ],
        );
      },
    );
  }
}

class _AboutItem {
  final IconData icon;
  final String label;
  final String value;

  const _AboutItem(
      {required this.icon, required this.label, required this.value});
}