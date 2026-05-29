import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class OzBahanyButtonsWidget extends StatelessWidget {
  const OzBahanyButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final buttons = [
      _OzBahanyButton(
        iconUrl: 'assets/icons/streamline.svg',
        label: l10n.dizayn_sazlamalary,
        onTap: () {},
      ),
      _OzBahanyButton(
        iconUrl: 'assets/icons/group.svg',
        label: l10n.logotypin_gornushi,
        onTap: () {},
      ),
      _OzBahanyButton(
        iconUrl: 'assets/icons/free_box.svg',
        label: l10n.toplumyn_sazlamalary,
        onTap: () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: buttons.asMap().entries.map((entry) {
            final b = entry.value;
            final isLast = entry.key == buttons.length - 1;
            return Expanded(
              child: GestureDetector(
                onTap: b.onTap,
                child: Container(
                  margin: EdgeInsets.only(right: isLast ? 0 : 8),
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        b.iconUrl,
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        b.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.navWhite,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _OzBahanyButton {
  final String iconUrl;
  final String label;
  final VoidCallback onTap;

  const _OzBahanyButton({
    required this.iconUrl,
    required this.label,
    required this.onTap,
  });
}