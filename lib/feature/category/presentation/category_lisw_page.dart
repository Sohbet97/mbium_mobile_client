import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/main_category_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../generated/l10n.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key, required this.categories});
  final List<CategoryModel> categories;
  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cats = widget.categories;
    final languageCode = context.read<MainBloc>().state.languageCode;
    return Row(
      children: [
        Flexible(
          flex: 70,
          child: _selectedCategory == null
              ? SizedBox.shrink()
              : _selectedCategory!.children.isEmpty
              ? MyEmptyWidget(emptyText: S.of(context).category_empty)
              : CustomScrollView(
                  slivers: [
                    SliverGrid.builder(
                      itemCount: _selectedCategory?.children.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 110,
                      ),
                      itemBuilder: (context, index) {
                        final model = _selectedCategory!.children[index];
                        return _BuildSecondaryCategory(
                          model: model,
                          languageCode: languageCode,
                          onTap: () {
                            // TODO click to sec cat
                          },
                        );
                      },
                    ),

                    // TODO products
                  ],
                ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: 2,
          margin: const EdgeInsets.only(right: 2),
          color: Colors.grey.shade300,
        ),

        Flexible(
          flex: 33,
          child: ListView.builder(
            itemCount: cats.length,
            itemBuilder: (context, index) => MainCategoryWidget(
              model: cats[index],
              isSelected: _selectedCategory == cats[index],
              onTap: () {
                setState(() {
                  _selectedCategory = cats[index];
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _BuildSecondaryCategory extends StatelessWidget {
  const _BuildSecondaryCategory({
    required this.model,
    required this.languageCode,
    required this.onTap,
  });

  final CategoryModel model;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Expanded(
              child: model.icon == null
                  ? Icon(Icons.category, color: Colors.grey)
                  : Text(model.icon!, style: TextStyle(fontSize: 30)),
            ),
            const SizedBox(height: 3),
            Text(
              model.getNameByLanguage(languageCode),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
