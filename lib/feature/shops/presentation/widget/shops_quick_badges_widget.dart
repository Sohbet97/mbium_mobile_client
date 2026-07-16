import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class ShopsQuickBadgesWidget extends StatelessWidget {
  final VoidCallback? onVerifiedTap;
  final VoidCallback? onExhibitionTap;

  const ShopsQuickBadgesWidget({
    super.key,
    this.onVerifiedTap,
    this.onExhibitionTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _BadgeCard(
              icon: Icons.verified_outlined,
              title: l10n.tassyklanan_hunarmen_ondurji,
              onTap: onVerifiedTap,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _BadgeCard(
              icon: Icons.storefront_outlined,
              title: l10n.onlayn_sowda_sergisi,
              onTap: onExhibitionTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const _BadgeCard({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.navBarGrey),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 22),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: textStyles.s13w600clBlack,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}