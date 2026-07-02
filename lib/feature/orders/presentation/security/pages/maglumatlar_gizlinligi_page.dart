import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../widgets/gorag_section_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class MaglumatlarGizlinligiPage extends StatelessWidget {
  const MaglumatlarGizlinligiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    const descStyle = TextStyle(
      fontSize: 13,
      color: AppColors.lightTextSecondary,
      height: 1.5,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.gorag, style: textStyles.s16w600clBlack),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.maglumatlaryn_gizlinligi,
              style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(l10n.maglumatlaryn_gizlinligi_desc, style: descStyle),
            const SizedBox(height: 20),

            GoragSectionWidget(
              icon: Icons.shield_outlined,
              iconColor: AppColors.primaryGreen,
              title: l10n.maglumat_goragy,
              children: [
                Text(l10n.maglumat_goragy_desc, style: descStyle),
              ],
            ),
            const SizedBox(height: 12),

            GoragSectionWidget(
              icon: Icons.security_outlined,
              iconColor: AppColors.primaryGreen,
              title: l10n.howpuszlyk_caryaleri,
              children: [
                Text(l10n.howpsuzlyk_caryaleri_desc, style: descStyle),
              ],
            ),
            const SizedBox(height: 12),

            GoragSectionWidget(
              icon: Icons.manage_accounts_outlined,
              iconColor: AppColors.primaryGreen,
              title: l10n.oz_maglumatlarynyzyn_dolandyryn,
              children: [
                Text(l10n.oz_maglumatlarynyzyn_dolandyryn_desc, style: descStyle),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}