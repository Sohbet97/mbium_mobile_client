import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/feature/brands/models/brand_model.dart';
import 'package:mbium_mobile_client/feature/brands/presentation/widgets/brand_detail_widgets.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';
import 'package:shimmer/shimmer.dart';

import '../../../generated/l10n.dart';

class BrandDetailScreen extends StatefulWidget {
  const BrandDetailScreen({super.key, required this.brandModel});

  final BrandModel brandModel;

  @override
  State<BrandDetailScreen> createState() => _BrandDetailScreenState();
}

class _BrandDetailScreenState extends State<BrandDetailScreen> {
  final _scrollController = ScrollController();
  final List<ProductModel> _products = [];

  late final ProductBloc _productBloc;

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _productBloc.add(LoadProducts(FilterModel(brandId: widget.brandModel.id)));
    _scrollController.addListener(_onScroll);
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
      _productBloc.add(LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.brandModel.name)),
      body: BlocConsumer<ProductBloc, ProductState>(
        bloc: _productBloc,
        listener: (context, state) {
          if (state is ProductLoading) {
            _products.clear();
          }
          if (state is ProductLoaded) {
            _products
              ..clear()
              ..addAll(state.products);
          }
        },
        builder: (context, state) {
          final isLoadingMore = state is ProductLoaded && state.isLoadingMore;
          final isInitialLoading = state is ProductLoading && _products.isEmpty;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: BrandDetailHeader(brand: widget.brandModel),
              ),
              SliverToBoxAdapter(
                child: BrandDetailSectionTitle(title: loc.products),
              ),
              if (isInitialLoading)
                SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childCount: 6,
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(height: 200, color: Colors.white),
                  ),
                )
              else if (_products.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 35),
                    child: MyEmptyWidget(emptyText: loc.noDataAvailable),
                  ),
                )
              else
                SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  childCount: _products.length + (isLoadingMore ? 2 : 0),
                  itemBuilder: (context, index) {
                    if (index < _products.length) {
                      return ProductMassonGridItem(product: _products[index]);
                    }
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(height: 200, color: Colors.white),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
