import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';

import '../../../../generated/l10n.dart';

class HomeMenuWidget extends StatelessWidget {
  const HomeMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildItem(
            iconUrl: 'assets/icons/category.svg',
            title: localization.category,
            subTitle: localization.boyunca,
            color: !isDark ? Colors.white : Colors.grey.shade800,
            onTap: () {
              Navigator.pushNamed(context, '/categories');
            },
          ),

          const SizedBox(width: 8),

          _buildItem(
            iconUrl: 'assets/icons/top.svg',
            title: localization.top,
            subTitle: localization.satys,
            color: !isDark ? Colors.white : Colors.grey.shade800,
            onTap: () {
              Navigator.pushNamed(context, '/top-products');
            },
          ),

          const SizedBox(width: 8),

          _buildItem(
            iconUrl: 'assets/icons/live.svg',
            title: localization.live,
            subTitle: localization.satys,
            color: !isDark ? Colors.white : Colors.grey.shade800,
            onTap: () {},
          ),

          const SizedBox(width: 8),

          _buildItem(
            iconUrl: 'assets/icons/group.svg',
            title: localization.brands,
            subTitle: localization.boyunca,
            color: !isDark ? Colors.white : Colors.grey.shade800,
            onTap: () {
              Navigator.pushNamed(context, '/brands');
            },
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Container _buildItem({
    required String iconUrl,
    required String title,
    required String subTitle,
    required VoidCallback onTap,
    required Color color,
  }) => Container(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(6),
    ),
    width: 120,
    child: GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgIcon(iconName: iconUrl),
          const SizedBox(width: 2),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(subTitle),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
