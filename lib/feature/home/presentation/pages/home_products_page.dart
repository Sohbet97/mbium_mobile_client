import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/home_banner_widget.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/home_menu_widget.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/category_tabs_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/collections_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/delivery_coin_banner_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/promo_banner_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';
import 'package:mbium_mobile_client/feature/search/model/search_model.dart';

import '../../../../core/constants/my_empty_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../generated/l10n.dart';

class HomeProductsPage extends StatefulWidget {
  const HomeProductsPage({super.key});

  @override
  State<HomeProductsPage> createState() => _HomeProductsPageState();
}

class _HomeProductsPageState extends State<HomeProductsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late ProductBloc _productBloc;
  FilterModel _filter = FilterModel();
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
      const LoadCategoriesEvent(isRefresh: false),
    );
    _productBloc = context.read<ProductBloc>()..add(LoadProducts(_filter));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(const LoadMoreProducts());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SearchWidget(
                  controller: _searchController,
                  onTapPhoto: () {
                    final model = SearchModel(isImageDetect: true);
                    Navigator.pushNamed(
                      context,
                      '/searchScreen',
                      arguments: model,
                    );
                  },
                  onTapAudio: () {},
                  onTapAi: () {},
                  onSubmit: () {
                    setState(() {
                      _filter = FilterModel(text: _searchController.text);
                      _productBloc.add(LoadProducts(_filter));
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: HomeMenuWidget(),
              ),
            ],
          ),
        ),
        if (_searchController.text.isEmpty)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const PromoBannerWidget(),

                const SizedBox(height: 16),

                const ProductCollectionsWidget(),

                const SizedBox(height: 20),
                CategoryTabsWidget(
                  onCategorySelected: (int p1) {
                    setState(() {
                      p1 == 0
                          ? _filter = FilterModel(categoryId: null)
                          : _filter = FilterModel(categoryId: p1);
                      _productBloc.add(LoadProducts(_filter));
                    });
                  },
                ),

                const SizedBox(height: 10),
                // ProductSectionWidget(products: _mockProducts),
                const DeliveryCoinBannerWidget(),
              ],
            ),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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

            if (state is ProductLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return SliverToBoxAdapter(
                  child: MyEmptyWidget(emptyText: S.of(context).product_empty),
                );
              }

              final bannerState = context.watch<BannerBloc>().state;
              final hasHomeBanners =
                  bannerState is BannerLoaded &&
                  bannerState
                      .bannersByType('home_hero')
                      .any((b) => b.isCurrentlyActive);

              final entries = _buildHomeGridEntries(
                products: products,
                hasHomeBanners: hasHomeBanners,
                pageSize: state.filter.limit,
              );

              return SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return entry.carouselIndex != null
                      ? HomeBannerWidget(insertionIndex: entry.carouselIndex!)
                      : ProductMassonGridItem(product: entry.product!);
                },
                childCount: entries.length,
              );
            }
            return SliverToBoxAdapter();
          },
        ),
      ],
    );
  }
}

List<_HomeGridEntry> _buildHomeGridEntries({
  required List<ProductModel> products,
  required bool hasHomeBanners,
  required int pageSize,
}) {
  if (pageSize <= 0 || !hasHomeBanners) {
    return products.map(_HomeGridEntry.product).toList();
  }

  final entries = <_HomeGridEntry>[];
  var insertionIndex = 0;
  for (var chunkStart = 0; chunkStart < products.length; chunkStart += pageSize) {
    entries.add(_HomeGridEntry.banner(insertionIndex));
    insertionIndex++;

    final chunkEnd = (chunkStart + pageSize).clamp(0, products.length);
    for (var i = chunkStart; i < chunkEnd; i++) {
      entries.add(_HomeGridEntry.product(products[i]));
    }
  }
  return entries;
}

class _HomeGridEntry {
  final ProductModel? product;
  final int? carouselIndex;

  const _HomeGridEntry.product(this.product) : carouselIndex = null;

  const _HomeGridEntry.banner(this.carouselIndex) : product = null;
}
