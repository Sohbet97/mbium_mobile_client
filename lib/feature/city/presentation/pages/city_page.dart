import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/city/presentation/widget/city_category_tabs_widget.dart';
import 'package:mbium_mobile_client/feature/city/presentation/widget/city_horizontal_list_widget.dart';
import 'package:mbium_mobile_client/feature/city/presentation/widget/city_maslahat_widget.dart';
import 'package:mbium_mobile_client/feature/city/presentation/widget/city_banner_product_widget.dart';

class CityPage extends StatefulWidget {
  const CityPage({super.key});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _productController = ScrollController();

  late ProductBloc _productBloc;
  late ProductBloc _maslahatBloc;
  late ProductBloc _bannerProductBloc;

  FilterModel _productFilter = const FilterModel();
  final List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
      const LoadCategoriesEvent(isRefresh: false),
    );

    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _productBloc.add(LoadProducts(_productFilter));
    _productController.addListener(_onScrollProduct);

    _maslahatBloc = ProductBloc(repository: context.read<ProductRepository>());
    _maslahatBloc.add(const LoadProducts(FilterModel(limit: 10)));

    _bannerProductBloc = ProductBloc(
      repository: context.read<ProductRepository>(),
    );
    _bannerProductBloc.add(const LoadProducts(FilterModel(limit: 10)));
  }

  void _onScrollProduct() {
    if (_productController.position.pixels >=
        _productController.position.maxScrollExtent - 200) {
      _productBloc.add(LoadMoreProducts());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _productController.dispose();
    _productBloc.close();
    _maslahatBloc.close();
    _bannerProductBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SearchWidget(controller: _searchController, onSubmit: () {}),
          ),
          const SizedBox(height: 16),

          BlocBuilder<ProductBloc, ProductState>(
            bloc: _productBloc,
            builder: (context, state) {
              if (state is ProductLoaded) {
                _products.addAll(state.products);
              }
              return CityHorizontalListWidget(
                productBloc: _productBloc,
                scrollController: _productController,
                products: _products,
              );
            },
          ),
          const SizedBox(height: 12),

          CityCategoryTabsWidget(
            onCategorySelected: (id) {
              setState(() {
                _productFilter = FilterModel(categoryId: id);
                _products.clear();
                _productBloc.add(LoadProducts(_productFilter));
              });
            },
          ),
          const SizedBox(height: 16),

          CityMaslahatWidget(productBloc: _maslahatBloc),
          const SizedBox(height: 20),

          CityBannerProductWidget(productBloc: _bannerProductBloc),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
