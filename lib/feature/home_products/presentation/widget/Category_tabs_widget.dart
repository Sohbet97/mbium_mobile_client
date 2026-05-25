import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../generated/l10n.dart';

class CategoryTabsWidget extends StatefulWidget {
  final Function(int) onCategorySelected;
  const CategoryTabsWidget({super.key, required this.onCategorySelected});
  @override
  State<CategoryTabsWidget> createState() => _CategoryTabsWidgetState();
}

class _CategoryTabsWidgetState extends State<CategoryTabsWidget> {
  int _isSelected = 0;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
      const LoadCategoriesEvent(isRefresh: false),
    );
  }

  void _handleCategorySelect(int i) {
    setState(() {
      _isSelected = i;
      widget.onCategorySelected(i);
    });
  }

  void _showModalCategory(
    BuildContext context,
    List<CategoryModel> cats,
  ) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 8,
            right: 8,
            bottom: 10,
          ),
          child: SafeArea(
            child: Column(
              children: [
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cats.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = cats[index];
                      return _buildItemExpansion(item, (model) {
                        Navigator.pop(context, model);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (result is CategoryModel) {
      // TODO select category
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final languageCode = context.read<MainBloc>().state.languageCode;
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is LoadCategoriesProgress) {
          return _ShimmerEfect();
        }

        if (state is LoadCategoriesError) return SizedBox.shrink();

        if (state is LoadCategoriesSuccess) {
          final cats = state.categories;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cats.length + 1,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _buildItem(
                          localization.ahlisi,
                          () => _handleCategorySelect(0),
                          _isSelected == 0,
                        );
                      }
                      return _buildItem(
                        cats[index - 1].getNameByLanguage(languageCode),
                        () => _handleCategorySelect(index + 1),
                        _isSelected == index + 1,
                      );
                    },
                  ),
                ),

                GestureDetector(
                  onTap: () => _showModalCategory(context, cats),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4, left: 3),
                    child: Icon(Icons.arrow_downward),
                  ),
                ),
              ],
            ),
          );
        }
        return _ShimmerEfect();
      },
    );
  }

  ExpansionTile _buildItemExpansion(
    CategoryModel model,
    ValueChanged<CategoryModel> onInitTap,
  ) {
    return ExpansionTile(
      title: Text(
        model.getNameByLanguage(context.read<MainBloc>().state.languageCode),
      ),
      // Если детей нет, можно обрабатывать тап на саму плитку
      onExpansionChanged: (isExpanded) {
        if (model.children.isEmpty) {
          onInitTap(model);
        }
      },
      // Рекурсивно передаем колбэк дальше вниз по дереву
      children: model.children
          .map((item) => _buildItemExpansion(item, onInitTap))
          .toList(),
    );
  }

  Widget _buildItem(String name, VoidCallback onSelect, bool isSelected) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryGreen.withOpacity(0.8)
              : Colors.grey.shade300,
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.secondaryGreen.withOpacity(0.8),
                    AppColors.secondaryGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ShimmerEfect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
      child: SizedBox(
        height: 30,
        child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,

          itemBuilder: (BuildContext context, int index) {
            return Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              child: Container(
                width: 90,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
