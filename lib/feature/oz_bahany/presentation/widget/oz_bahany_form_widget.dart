import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class OzBahanyFormWidget extends StatefulWidget {
  const OzBahanyFormWidget({super.key});

  @override
  State<OzBahanyFormWidget> createState() => _OzBahanyFormWidgetState();
}

class _OzBahanyFormWidgetState extends State<OzBahanyFormWidget> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.lightBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.navWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image_outlined,
                      color: AppColors.textLightGrey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.oz_bahany_surat_yuklan,
                      style: const TextStyle(
                        color: AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: (val) => setState(() => _isAgreed = val ?? false),
                  fillColor: WidgetStateProperty.resolveWith(
                    (states) => states.contains(WidgetState.selected)
                        ? AppColors.bonusBannerTextGreen
                        : AppColors.navWhite.withValues(alpha: 0.3),
                  ),
                  side: BorderSide(
                    color: AppColors.navWhite.withValues(alpha: 0.5),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: AppColors.navWhite,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(text: l10n.oz_bahany_ugratmak_bilen),
                          TextSpan(
                            text: ' ${l10n.mbium_hyzmat_sertleri}',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' ${l10n.we_gizlilik_syyyasatyna}'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.navWhite,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.ai_komegi_bilen_obs,
                  style: const TextStyle(
                    color: AppColors.navWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/rfqScreen');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navWhite,
                  side: const BorderSide(color: AppColors.navWhite, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  l10n.takyk_isleglerini_duzun,
                  style: textStyles.s13w600clBlack.copyWith(
                    color: AppColors.navWhite,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
