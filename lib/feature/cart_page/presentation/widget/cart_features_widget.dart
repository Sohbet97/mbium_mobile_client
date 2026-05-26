import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../../generated/l10n.dart';

class CartFeaturesWidget extends StatelessWidget {
  const CartFeaturesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final features = [
      _CartFeature(icon: Icons.security_outlined,        label: l10n.ynamly_tolegier),
      _CartFeature(icon: Icons.local_shipping_outlined,  label: l10n.kepillendirilen_eltip_bermek),
      _CartFeature(icon: Icons.account_balance_wallet_outlined, label: l10n.yza_gaytarmak_goragy),
      _CartFeature(icon: Icons.headset_mic_outlined,     label: '24/7\nGoldaw'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bonusBannerGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: List.generate(features.length, (i) {
              return Expanded(
                child: Container(
                  decoration: i > 0
                      ? const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: AppColors.bonusBannerBorderGreen,
                              width: 0.8,
                            ),
                          ),
                        )
                      : null,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        features[i].icon,
                        size: 28,
                        color: AppColors.bonusBannerTextGreen,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        features[i].label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.aiTextBlack,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
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