import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class PromoBannerWidget extends StatelessWidget {
  const PromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _BannerItem(
              icon: Icons.local_shipping_outlined,
              title: l10n.mugt_dastawka,
              subtitle: l10n.mbium_coin_bilen,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _BannerItem(
              icon: Icons.shield_outlined,
              title: l10n.baha_goraglylygy,
              subtitle: l10n.gune_cenli,
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _BannerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bonusBannerGreen,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.bonusBannerBorderGreen.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.bonusBannerTextGreen, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.aiTextBlack,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textLightGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}