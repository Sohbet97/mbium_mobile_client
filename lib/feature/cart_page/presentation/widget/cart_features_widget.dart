import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../../generated/l10n.dart';

class CartFeaturesWidget extends StatelessWidget {
  const CartFeaturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final features = [
      _CartFeature(icon: Icons.verified_user_outlined,  label: l10n.ynamly_tolegier),
      _CartFeature(icon: Icons.local_shipping_outlined, label: l10n.kepillendirilen_eltip_bermek),
      _CartFeature(icon: Icons.refresh_outlined,        label: l10n.yza_gaytarmak_goragy),
      _CartFeature(icon: Icons.support_agent_outlined,  label: '24/7\nGoldaw'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.navBarGrey, width: 0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: List.generate(features.length, (i) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.bonusBannerGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(features[i].icon,
                                  size: 22,
                                  color: AppColors.bonusBannerTextGreen),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              features[i].label,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: AppColors.aiTextBlack,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < features.length - 1)
                      VerticalDivider(
                        width: 1,
                        thickness: 0.8,
                        color: AppColors.navBarGrey,
                        indent: 8,
                        endIndent: 8,
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _CartFeature {
  final IconData icon;
  final String label;
  const _CartFeature({required this.icon, required this.label});
}