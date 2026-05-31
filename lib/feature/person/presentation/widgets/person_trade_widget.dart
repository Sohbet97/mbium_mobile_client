import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class PersonTradeWidget extends StatelessWidget {
  const PersonTradeWidget({super.key});

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
      child: ListTile(
        title: Text(l10n.sowda_maglumatlary, style: textStyles.s13w600clBlack),
        subtitle: Text(
          l10n.sowda_maglumatlary_desc,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded,
            size: 14, color: AppColors.lightTextSecondary),
        onTap: () {},
      ),
    );
  }
}