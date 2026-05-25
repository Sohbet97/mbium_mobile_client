import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import '../../../../generated/l10n.dart';

class CategoryTabsWidget extends StatefulWidget {
  final ValueChanged<CategoryModel>? onCategorySelected;

  const CategoryTabsWidget({
    super.key,
    this.onCategorySelected,
  });

  @override
  State<CategoryTabsWidget> createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  int _selectedIndex = 0;
  bool _expanded = false;

  static const int _visibleCount = 4;

  String _getCategoryName(CategoryModel category) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'ru':
        return category.nameRu.isNotEmpty ? category.nameRu : category.name;
      case 'en':
        return category.nameEng.isNotEmpty ? category.nameEng : category.name;
      default:
        return category.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is LoadCategoriesProgress) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state is LoadCategoriesError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.of(context).nasazlyk_yuze_cykdy,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          );
        }

        if (state is LoadCategoriesSuccess) {
          final categories = state.categories;
          if (categories.isEmpty) return const SizedBox.shrink();

          final showExpand = categories.length > _visibleCount;
          final displayList = _expanded
              ? categories
              : categories.take(_visibleCount).toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: List.generate(displayList.length, (i) {
                      final isSelected = _selectedIndex == i;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedIndex = i);
                          widget.onCategorySelected?.call(displayList[i]);
                        },
                        child: Text(
                          _getCategoryName(displayList[i]),
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

        return const SizedBox.shrink();
      },
    );
  }
}