import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import '../../../../generated/l10n.dart';

class ShopsMenuWidget extends StatelessWidget {
  const ShopsMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? Colors.grey.shade800 : Colors.white;

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        children: [
          _buildItem(
            iconUrl: 'assets/icons/category.svg',
            title: l10n.category.toUpperCase(),
            subTitle: l10n.boyunca,
            color: color,
            onTap: () => Navigator.pushNamed(context, '/categories'),
          ),
          const SizedBox(width: 8),
          _buildItem(
            iconUrl: 'assets/icons/gravity.svg',
            title: l10n.oz_bahany_sayla,
            subTitle: '',
            color: color,
            onTap: () {
              Navigator.pushNamed(context, '/ozBahanySayla');
            },
          ),
          const SizedBox(width: 8),
          _buildItem(
            iconUrl: 'assets/icons/top.svg',
            title: l10n.top,
            subTitle: l10n.satys,
            color: color,
            onTap: () => Navigator.pushNamed(context, '/top-products'),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String iconUrl,
    required String title,
    required String subTitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgIcon(iconName: iconUrl),
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  if (subTitle.isNotEmpty)
                    Text(subTitle, style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
