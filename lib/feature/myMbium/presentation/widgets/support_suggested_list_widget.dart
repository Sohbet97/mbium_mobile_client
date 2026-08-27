import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/support_question_row_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class SupportSuggestedListWidget extends StatelessWidget {
  const SupportSuggestedListWidget({super.key, required this.onTap});
  final Function(String message) onTap;
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;
    final questions = [
      l10n.harydy_hacan_alaryn,
      l10n.sowda_kepilligindaki_sargydymy,
      l10n.trade_assurance_bilen_goralyan_sargyt,
      l10n.bu_ucin_edijilik_yagtybarlylygyny,
      l10n.haryt_bilen_baglanyshykly_problema,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.auto_awesome,
              color: AppColors.primaryGreen,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(l10n.size_teklip_edilyar, style: textStyles.s13w600clBlack),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: questions
              .map(
                (q) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SupportQuestionRowWidget(text: q, onTap: () => onTap(q)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
