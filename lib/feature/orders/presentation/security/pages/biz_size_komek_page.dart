import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class BizSizeKomekPage extends StatelessWidget {
  const BizSizeKomekPage({super.key});

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
              l10n.biz_size_nadip_komek,
              style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 16),

            // Arama
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.navBarGrey),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.search, color: AppColors.lightTextSecondary),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: l10n.gozlayish_ya_da_sorag_berin,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Hyzmat haýyşynyň taryhy
            _buildMenuRow(context, l10n.hyzmat_hayysyny_taryh),
            const SizedBox(height: 20),

            // Maslahat berilýär
            Row(
              children: [
                const Icon(Icons.flash_on, color: AppColors.starYellow, size: 18),
                const SizedBox(width: 6),
                Text(l10n.maslahat_beriyor, style: textStyles.s13w600clBlack),
              ],
            ),
            const SizedBox(height: 12),

            _buildQuestionRow(context, l10n.harydy_hacan_alaryn),
            const SizedBox(height: 8),
            _buildQuestionRow(context, l10n.sowda_kepilligindaki_sargydymy),
            const SizedBox(height: 8),
            _buildQuestionRow(context, l10n.trade_assurance_bilen_goralyan_sargyt),
            const SizedBox(height: 8),
            _buildQuestionRow(context, l10n.bu_ucin_edijilik_yagtybarlylygyny),
            const SizedBox(height: 8),
            _buildQuestionRow(context, l10n.haryt_bilen_baglanyshykly_problema),
            const SizedBox(height: 20),

            // KSS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.kss, style: textStyles.s13w600clBlack),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    l10n.ahlisin_gorkez,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {},
              child: Text(
                l10n.trade_assurance_bilen_sargyt,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.lightTextPrimary,
                )),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.lightTextSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionRow(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextPrimary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.lightTextSecondary),
          ],
        ),
      ),
    );
  }
}