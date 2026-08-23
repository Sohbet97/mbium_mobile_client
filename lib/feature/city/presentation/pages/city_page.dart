import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/home_banner_widget.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/city/presentation/widget/city_banner_carousel_widget.dart';
import 'package:mbium_mobile_client/feature/city/presentation/widget/city_maslahat_widget.dart';
import 'package:mbium_mobile_client/feature/city/presentation/widget/city_region_list_widget.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/home_product_filtres.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';

import '../../../../generated/l10n.dart';

class CityPage extends StatefulWidget {
  const CityPage({super.key});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  late ProductBloc _productBloc;
  late ProductBloc _maslahatBloc;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
      const LoadCategoriesEvent(isRefresh: false),
    );

    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _productBloc.add(const LoadProducts(FilterModel()));
    _scrollController.addListener(_onScroll);

    _maslahatBloc = ProductBloc(repository: context.read<ProductRepository>());
    _maslahatBloc.add(const LoadProducts(FilterModel(limit: 10)));
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
    _scrollController.dispose();
    _productBloc.close();
    _maslahatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    final filtres = <HomeFilterModel>[
      HomeFilterModel(name: localization.all, iconData: Icons.favorite),
      HomeFilterModel(
        name: localization.arzalnasyklar,
        iconData: Icons.arrow_downward,
      ),
      HomeFilterModel(
        name: localization.mugt_dastawka,
        iconData: Icons.delivery_dining,
      ),
      HomeFilterModel(name: localization.yuzden_arzan, iconData: Icons.money),
    ];

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SearchWidget(
                  controller: _searchController,
                  onSubmit: () {},
                ),
              ),
              const SizedBox(height: 16),

              const CityBannerCarouselWidget(),
              const SizedBox(height: 16),

              const CityRegionListWidget(),
              const SizedBox(height: 16),
            ],
          ),
        ),
        BlocBuilder<ProductBloc, ProductState>(
          bloc: _productBloc,
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
                  child: MyEmptyWidget(emptyText: localization.product_empty),
                );
              }

              final bannerState = context.watch<BannerBloc>().state;
              final hasBanners =
                  bannerState is BannerLoaded &&
                  bannerState
                      .bannersByType('home_hero')
                      .any((b) => b.isCurrentlyActive);

              final entries = _buildCityGridEntries(
                products: products,
                hasBanners: hasBanners,
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

            return const SliverToBoxAdapter();
          },
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

List<_CityGridEntry> _buildCityGridEntries({
  required List<ProductModel> products,
  required bool hasBanners,
  required int pageSize,
}) {
  if (pageSize <= 0 || !hasBanners) {
    return products.map(_CityGridEntry.product).toList();
  }

  final entries = <_CityGridEntry>[];
  var insertionIndex = 0;
  for (
    var chunkStart = 0;
    chunkStart < products.length;
    chunkStart += pageSize
  ) {
    entries.add(_CityGridEntry.banner(insertionIndex));
    insertionIndex++;

    final chunkEnd = (chunkStart + pageSize).clamp(0, products.length);
    for (var i = chunkStart; i < chunkEnd; i++) {
      entries.add(_CityGridEntry.product(products[i]));
    }
  }
  return entries;
}

class _CityGridEntry {
  final ProductModel? product;
  final int? carouselIndex;

  const _CityGridEntry.product(this.product) : carouselIndex = null;

  const _CityGridEntry.banner(this.carouselIndex) : product = null;
}
