import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReviewFilterChipsWidget extends StatelessWidget {
  final int? selectedRating;
  final ValueChanged<int?> onSelect;
  final VoidCallback onFilterTap;

  const ReviewFilterChipsWidget({
    super.key,
    required this.selectedRating,
    required this.onSelect,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _Chip(
            label: l10n.hemmesi,
            selected: selectedRating == null,
            onTap: () => onSelect(null),
          ),
          const SizedBox(width: 8),
          for (final star in [5, 4, 3])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _Chip(
                label: '$star ★',
                selected: selectedRating == star,
                onTap: () => onSelect(star),
              ),
            ),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.navBarGrey),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.tune, size: 18, color: AppColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryGreen : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primaryGreen : AppColors.navBarGrey),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.navWhite : AppColors.lightTextSecondary,
          ),
        ),
      ),
    );
  }
}