import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/core/widgets/my_error_widget.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';
import 'package:mbium_mobile_client/feature/shops/bloc/shop_bloc.dart';
import 'package:mbium_mobile_client/feature/shops/data/shop_repository.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_filter_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_item_card.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../core/constants/my_empty_widget.dart';
import '../../../generated/l10n.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key, required this.category});

  final CategoryModel category;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late final ProductBloc _productBloc;
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String? _sort;
  String? _searchText;

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _scrollController.addListener(_onScroll);
    _reloadProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _productBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(const LoadMoreProducts());
    }
  }

  void _reloadProducts() {
    _productBloc.add(
      LoadProducts(
        FilterModel(
          categoryId: widget.category.id,
          sort: _sort,
          text: _searchText,
        ),
      ),
    );
  }

  void _onSortChanged(String? sort) {
    setState(() => _sort = sort);
    _reloadProducts();
  }

  void _onSearchSubmit() {
    final text = _searchController.text.trim();
    setState(() => _searchText = text.isEmpty ? null : text);
    _reloadProducts();
  }

  void _onSearchClear() {
    _searchController.clear();
    setState(() => _searchText = null);
    _reloadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.read<MainBloc>().state.languageCode;
    final localization = S.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category.getNameByLanguage(languageCode)),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _CategorySearchField(
                controller: _searchController,
                hasText: _searchText != null,
                onSubmit: _onSearchSubmit,
                onClear: _onSearchClear,
              ),
            ),
            TabBar(
              tabs: [
                Tab(text: localization.harytlar),
                Tab(text: localization.dukanlar),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProductsTab(),
                  _ShopsTab(
                    category: widget.category,
                    searchText: _searchText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsTab() {
    return BlocProvider.value(
      value: _productBloc,
      child: Column(
        children: [
          _SortChipsRow(selected: _sort, onChanged: _onSortChanged),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const MyLoadingWidget();
                }

                if (state is ProductError) {
                  return MyErrorWidget(
                    message: state.message,
                    onReload: () => _productBloc.add(const RefreshProducts()),
                  );
                }

                if (state is ProductLoaded) {
                  if (state.products.isEmpty) {
                    return MyEmptyWidget(
                      emptyText: S.of(context).product_empty,
                    );
                  }

                  return MasonryGridView.count(
                    controller: _scrollController,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    padding: const EdgeInsets.all(12),
                    itemCount:
                        state.products.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.products.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: MyLoadingWidget(),
                        );
                      }
                      return ProductMassonGridItem(
                        product: state.products[index],
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopsTab extends StatefulWidget {
  const _ShopsTab({required this.category, this.searchText});

  final CategoryModel category;
  final String? searchText;

  @override
  State<_ShopsTab> createState() => _ShopsTabState();
}

class _ShopsTabState extends State<_ShopsTab> {
  late final ShopBloc _shopBloc;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _shopBloc = ShopBloc(repository: context.read<ShopRepository>());
    _scrollController.addListener(_onScroll);
    _reloadShops();
  }

  @override
  void didUpdateWidget(covariant _ShopsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchText != widget.searchText) {
      _reloadShops();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _shopBloc.close();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _shopBloc.add(const LoadMoreShops());
    }
  }

  void _reloadShops() {
    _shopBloc.add(
      LoadShops(
        ShopFilterModel(
          categoryId: widget.category.id,
          text: widget.searchText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _shopBloc,
      child: BlocBuilder<ShopBloc, ShopState>(
        builder: (context, state) {
          if (state is ShopLoading) {
            return const MyLoadingWidget();
          }

          if (state is ShopError) {
            return MyErrorWidget(
              message: state.message,
              onReload: () => _shopBloc.add(const RefreshShops()),
            );
          }

          if (state is ShopLoaded) {
            if (state.shops.isEmpty) {
              return MyEmptyWidget(emptyText: S.of(context).shop_empty);
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: state.shops.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.shops.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: MyLoadingWidget(),
                  );
                }
                return ShopItemCard(
                  shopModel: state.shops[index],
                  isShowProducts: false,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CategorySearchField extends StatelessWidget {
  const _CategorySearchField({
    required this.controller,
    required this.hasText,
    required this.onSubmit,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onSubmit;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.navBarGrey),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.search, size: 20, color: AppColors.lightTextSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onSubmit(),
              textInputAction: TextInputAction.search,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: S.of(context).search,
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (hasText)
            GestureDetector(
              onTap: onClear,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.close,
                  size: 18,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            )
          else
            const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class _SortChipsRow extends StatelessWidget {
  const _SortChipsRow({required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final options = <String?, String>{
      null: localization.all,
      'price_asc': localization.sort_price_asc,
      'price_desc': localization.sort_price_desc,
      'newest': localization.sort_newest,
    };

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final entry = options.entries.elementAt(index);
          final isSelected = selected == entry.key;

          return GestureDetector(
            onTap: () => onChanged(entry.key),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.navBarGrey,
                ),
              ),
              child: Center(
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
