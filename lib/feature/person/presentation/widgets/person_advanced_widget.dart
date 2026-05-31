import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class PersonAdvancedWidget extends StatelessWidget {
  const PersonAdvancedWidget({super.key});

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
          ListTile(
            title: Text(l10n.haryt_gozlegindaki_ileri_tutmalar,
                style: textStyles.s13w600clBlack),
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.lightTextSecondary),
            onTap: () {},
          ),
          const Divider(height: 1, indent: 16, endIndent: 16),
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/heart.svg',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.harytlar_ucin_shahsy_hodurlemeleri_alyn,
                        style: textStyles.s13w600clBlack,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.gozleg_tejribani_gowulandyrmak,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 14, color: AppColors.lightTextSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}