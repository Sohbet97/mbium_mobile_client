import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/widgets/support_question_row_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class SupportFaqListWidget extends StatelessWidget {
  const SupportFaqListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    final questions = [
      l10n.faq_tassyklama_telefon,
      l10n.faq_hasap_isjensizlesdi,
      l10n.faq_hasaba_girip_bilmesem,
      l10n.faq_haryt_maglumaty,
      l10n.faq_paroly_yatdan_cykarsam,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('FAQ', style: textStyles.s16w600clBlack),
            GestureDetector(
              onTap: () {},
              child: Text(
                l10n.ahlisin_gorkez,
                style: const TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Column(
          children: questions.asMap().entries.map((e) {
            final isLast = e.key == questions.length - 1;
            return SupportQuestionRowWidget(
              text: e.value,
              showBackground: false,
              showDivider: !isLast,
              onTap: () {},
            );
          }).toList(),
        ),
      ],
    );
  }
}