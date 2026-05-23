import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/core/widgets/my_error_widget.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/category/presentation/category_lisw_page.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/category_card.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/recommended_product_card.dart';

import '../../../generated/l10n.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategoriesEvent(isRefresh: false));
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final bloc = context.read<CategoryBloc>();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(localization.categories),
        surfaceTintColor: Theme.of(context).cardColor,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        buildWhen: (previous, current) =>
            current is LoadCategoriesError ||
            current is LoadCategoriesProgress ||
            current is LoadCategoriesSuccess,
        builder: (context, state) {
          if (state is LoadCategoriesProgress) {
            return const MyLoadingWidget();
          }

          if (state is LoadCategoriesError) {
            return MyErrorWidget(
              message: localization.nasazlyk_yuze_cykdy,
              onReload: () {
                bloc.add(LoadCategoriesEvent(isRefresh: true));
              },
            );
          }

          if (state is LoadCategoriesSuccess) {
            final cats = state.categories;

            return CategoryListPage(categories: cats);
            return SafeArea(
              child: Row(
                children: [
                  Expanded(
                    flex: 70,
                    child: ListView(
                      children: [
                        GridView.builder(
                          padding: EdgeInsets.all(11),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: cats.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 0.5,
                                crossAxisSpacing: 10,
                              ),
                          itemBuilder: (context, index) =>
                              CategoryCard(category: cats[index]),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 11),
                          child: Text('Maslahat berilyan harytlar'),
                        ),
                        SizedBox(height: 13),
                        SizedBox(
                          height: 92,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 11),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                                RecommendedProductCard(
                                  productName: 'birzat',
                                  advantages: ['gowy zat', 'yene bir gor'],
                                ),
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 10),
                            itemCount: 10,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),

                  Container(
                    width: 85,
                    color: Theme.of(context).hoverColor,
                    child: ListView.builder(
                      itemCount: 50,
                      itemBuilder: (context, index) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 13,
                        ),
                        child: Text('siz ucin'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
