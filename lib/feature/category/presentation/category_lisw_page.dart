import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/main_category_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/list_product_item.dart';
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
  late ProductBloc _productBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _scrollController.addListener(_onScroll);
    if (widget.categories.isNotEmpty) {
      _selectedCategory = widget.categories.first;
      _loadProductsForCategory(_selectedCategory!);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _productBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(const LoadMoreProducts());
    }
  }

  void _loadProductsForCategory(CategoryModel category) {
    _productBloc.add(LoadProducts(FilterModel()));
  }

  @override
  Widget build(BuildContext context) {
    final cats = widget.categories;
    final languageCode = context.read<MainBloc>().state.languageCode;

    return SafeArea(
      child: BlocProvider.value(
        value: _productBloc,
        child: Row(
          children: [
            Flexible(
              flex: 70,
              child: _selectedCategory == null
                  ? const SizedBox.shrink()
                  : _selectedCategory!.children.isEmpty
                  ? MyEmptyWidget(emptyText: S.of(context).category_empty)
                  : CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverGrid.builder(
                          itemCount: _selectedCategory!.children.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 110,
                              ),
                          itemBuilder: (context, index) {
                            final model = _selectedCategory!.children[index];
                            return _SecondaryCategory(
                              model: model,
                              languageCode: languageCode,
                              onTap: () {
                                _productBloc.add(
                                  LoadProducts(
                                    FilterModel(categoryId: model.id),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsetsGeometry.only(
                              top: 20,
                              left: 10,
                              bottom: 3,
                            ),
                            child: Text(
                              S.of(context).sizin_ucin,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            if (state is ProductLoading) {
                              return const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 24),
                                  child: MyLoadingWidget(),
                                ),
                              );
                            }

                            if (state is ProductLoaded) {
                              if (state.products.isEmpty) {
                                return SliverToBoxAdapter(
                                  child: MyEmptyWidget(
                                    emptyText: S.of(context).product_empty,
                                  ),
                                );
                              }
                              return SliverList.builder(
                                itemCount:
                                    state.products.length +
                                    (state.isLoadingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == state.products.length) {
                                    return const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      child: MyLoadingWidget(),
                                    );
                                  }
                                  final product = state.products[index];
                                  return ListProductItem(model: product);
                                },
                              );
                            }

                            if (state is ProductError) {
                              return SliverToBoxAdapter(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(state.message),
                                  ),
                                ),
                              );
                            }

                            return const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            );
                          },
                        ),
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
                    _loadProductsForCategory(cats[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecondaryCategory extends StatelessWidget {
  const _SecondaryCategory({
    required this.model,
    required this.languageCode,
    required this.onTap,
  });

  final CategoryModel model;
  final String languageCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: model.icon == null
                    ? const Icon(Icons.category, color: Colors.grey)
                    : Text(model.icon!, style: const TextStyle(fontSize: 30)),
              ),
              const SizedBox(height: 3),
              Text(
                model.getNameByLanguage(languageCode),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
