import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../widgets/gorag_section_widget.dart';
import '../widgets/gorag_link_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class GijeGundizleyinGoldawPage extends StatelessWidget {
  const GijeGundizleyinGoldawPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

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
              l10n.gije_gundizleyin_goldaw_page_title,
              style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 20),

            GoragSectionWidget(
              icon: Icons.support_agent_outlined,
              iconColor: AppColors.primaryGreen,
              title: l10n.hunarmenlerin_islender_wagtlayin_komegi,
              children: [
                Text(l10n.hunarmenlerin_islender_desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightTextSecondary,
                      height: 1.5,
                    )),
              ],
            ),
            const SizedBox(height: 12),

            GoragSectionWidget(
              icon: Icons.language_outlined,
              iconColor: AppColors.primaryGreen,
              title: l10n.durli_dillerde_jogap_beryaris,
              children: [
                Text(l10n.durli_dillerde_desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightTextSecondary,
                      height: 1.5,
                    )),
              ],
            ),
            const SizedBox(height: 12),

            GoragSectionWidget(
              icon: Icons.gavel_outlined,
              iconColor: AppColors.primaryGreen,
              title: l10n.jedelleri_coz_goldaw,
              children: [
                Text(l10n.jedelleri_coz_goldaw_desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightTextSecondary,
                      height: 1.5,
                    )),
                const SizedBox(height: 8),
                GoragLinkWidget(
                  text: l10n.goldaw_has_ginisleyin,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}