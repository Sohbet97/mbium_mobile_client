import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ShopsFilterChipsWidget extends StatefulWidget {
  const ShopsFilterChipsWidget({super.key});

  @override
  State<ShopsFilterChipsWidget> createState() => _ShopsFilterChipsWidgetState();
}

class _ShopsFilterChipsWidgetState extends State<ShopsFilterChipsWidget> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final chips = [
      l10n.obrazesler_boyunca_tayyarlanan,
      l10n.dalandyrys_sertifikaty_bolan,
      l10n.giri_mumkin,
    ];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final isSelected = _selected == i;
          return GestureDetector(
            onTap: () => setState(() => _selected = i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.navBarGrey,
                ),
              ),
              child: Text(
                chips[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}