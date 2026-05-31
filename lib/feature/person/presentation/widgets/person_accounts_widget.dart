import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class PersonAccountsWidget extends StatelessWidget {
  const PersonAccountsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.baglanan_hasaplar, style: textStyles.s13w600clBlack),
                const SizedBox(height: 4),
                Text(
                  l10n.baglanan_hasaplar_desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/google.svg',
              width: 22,
              height: 22,
            ),
            title: const Text('Google', style: TextStyle(fontSize: 14)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.baglanan,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.bonusBannerTextGreen,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.lightTextSecondary),
              ],
            ),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          ListTile(
            leading: const Icon(Icons.phone_outlined,
                color: AppColors.primaryGreen, size: 22),
            title: Text(l10n.telefon_belgi,
                style: const TextStyle(fontSize: 14)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.baglanmady,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.lightTextSecondary),
              ],
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}