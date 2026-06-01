import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class RfqHowToWidget extends StatelessWidget {
  const RfqHowToWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    final steps = [
      _RfqStep(number: 1, title: l10n.rfq_step1_title, desc: l10n.rfq_step1_desc),
      _RfqStep(number: 2, title: l10n.rfq_step2_title, desc: l10n.rfq_step2_desc),
      _RfqStep(number: 3, title: l10n.rfq_step3_title, desc: l10n.rfq_step3_desc),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.rfq_nahili_ulanmaly,
            style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isLast = i == steps.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Numara + çizgi
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.bonusBannerGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${step.number}',
                          style: const TextStyle(
                            color: AppColors.bonusBannerTextGreen,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 60,
                        color: AppColors.navBarGrey,
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Başlık + açıklama
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.title, style: textStyles.s13w600clBlack),
                        const SizedBox(height: 4),
                        Text(
                          step.desc,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.lightTextSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _RfqStep {
  final int number;
  final String title;
  final String desc;

  const _RfqStep({
    required this.number,
    required this.title,
    required this.desc,
  });
}