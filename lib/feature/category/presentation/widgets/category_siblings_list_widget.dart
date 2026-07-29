import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/main_category_widget.dart';

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
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return MainCategoryWidget(
          model: category,
          isSelected: selected?.id == category.id,
          onTap: () => onTap(category),
        );
      },
    );
  }
}
