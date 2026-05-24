import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class CategoryTabsWidget extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<int>? onCategorySelected;

  const CategoryTabsWidget({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<CategoryTabsWidget> createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  int _selectedIndex = 0;
  bool _expanded = false;

  
  static const int _visibleCount = 4;

  @override
  Widget build(BuildContext context) {
    final categories = widget.categories;
    final showExpand = categories.length > _visibleCount;
    final displayList =
        _expanded ? categories : categories.take(_visibleCount).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: List.generate(displayList.length, (i) {
                final isSelected = _selectedIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedIndex = i);
                    widget.onCategorySelected?.call(i);
                  },
                  child: Text(
                    displayList[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.lightTextSecondary,
                      decoration: isSelected
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: AppColors.primaryGreen,
                      decorationThickness: 2,
                    ),
                  ),
                );
              }),
            ),
          ),
          if (showExpand) ...[
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: AnimatedRotation(
                turns: _expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}