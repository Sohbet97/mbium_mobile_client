import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class SupportServiceRequestWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const SupportServiceRequestWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.navBarGrey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.hyzmat_hayysynyn_yagdayy, style: textStyles.s13w600clBlack),
            const Icon(Icons.arrow_forward, color: AppColors.lightTextSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}