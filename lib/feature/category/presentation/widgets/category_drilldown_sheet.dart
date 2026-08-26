import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/category_grid_item_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../../generated/l10n.dart';

/// Alibaba-style category drill-down: a draggable bottom sheet that opens on
/// a list of level-2 categories, then swaps to a grid of the tapped
/// category's level-3 children inside the same sheet. Tapping a level-3 tile
/// (or a childless level-2 row) finalizes the pick via [onCategorySelected].
class CategoryDrilldownSheet extends StatefulWidget {
  const CategoryDrilldownSheet({
    super.key,
    required this.levelTwoCategories,
    required this.onCategorySelected,
  });

  final List<CategoryModel> levelTwoCategories;
  final ValueChanged<CategoryModel> onCategorySelected;

  @override
  State<CategoryDrilldownSheet> createState() =>
      _CategoryDrilldownSheetState();
}

class _CategoryDrilldownSheetState extends State<CategoryDrilldownSheet> {
  CategoryModel? _levelTwoFocus;

  void _handleLevelTwoTap(CategoryModel category) {
    if (category.children.isEmpty) {
      widget.onCategorySelected(category);
      return;
    }
    setState(() => _levelTwoFocus = category);
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.read<MainBloc>().state.languageCode;
    final localization = S.of(context);
    final focus = _levelTwoFocus;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.navBarGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: focus != null
                        ? IconButton(
                            onPressed: () =>
                                setState(() => _levelTwoFocus = null),
                            icon: const Icon(Icons.arrow_back),
                          )
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      focus != null
                          ? focus.getNameByLanguage(languageCode)
                          : localization.categories,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
              const Divider(height: 1),
              Expanded(
                child: focus == null
                    ? ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: widget.levelTwoCategories.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final category = widget.levelTwoCategories[index];
                          return ListTile(
                            title: Text(
                              category.getNameByLanguage(languageCode),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _handleLevelTwoTap(category),
                          );
                        },
                      )
                    : GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 90,
                            ),
                        itemCount: focus.children.length,
                        itemBuilder: (context, index) {
                          final levelThree = focus.children[index];
                          return CategoryGridItemWidget(
                            model: levelThree,
                            languageCode: languageCode,
                            onTap: () =>
                                widget.onCategorySelected(levelThree),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
