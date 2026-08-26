import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/main_category_widget.dart';

/// Left rail of [CategoryListPage] — always lists every 1st-level (root)
/// category. Tapping one makes it the focused root shown in
/// [CategoryFocusPanelWidget].
class CategorySiblingsListWidget extends StatelessWidget {
  const CategorySiblingsListWidget({
    super.key,
    required this.categories,
    required this.selected,
    required this.onTap,
  });

  final List<CategoryModel> categories;
  final CategoryModel? selected;
  final ValueChanged<CategoryModel> onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return MainCategoryWidget(
            model: category,
            isSelected: selected?.id == category.id,
            onTap: () => onTap(category),
          );
        },
      ),
    );
  }
}
