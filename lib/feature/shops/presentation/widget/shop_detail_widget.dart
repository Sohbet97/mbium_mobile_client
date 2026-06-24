import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_header_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_info_row_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_verified_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_categories_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_about_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_details_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_cta_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_products_widget.dart';

class ShopDetailWidget extends StatefulWidget {
  const ShopDetailWidget({super.key, required this.model});
  final ShopDetailModel model;

  @override
  State<ShopDetailWidget> createState() => _ShopDetailWidgetState();
}

class _ShopDetailWidgetState extends State<ShopDetailWidget> {
  late ProductBloc _productBloc;
  final ScrollController _scrollController = ScrollController();
  final List<ProductModel> _products = [];
  bool _hasMore = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _productBloc.add(LoadProducts(FilterModel(shopId: widget.model.id)));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(LoadMoreProducts());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return BlocListener<ProductBloc, ProductState>(
      bloc: _productBloc,
      listener: (context, state) {
        if (state is ProductLoaded) {
          setState(() {
            _products.addAll(state.products);
            _hasMore = state.hasMore;
            _isLoadingMore = false;
          });
        }
        if (state is ProductLoading) {
          setState(() => _isLoadingMore = true);
        }
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ShopDetailHeaderWidget(model: widget.model),
          ),

          SliverToBoxAdapter(
            child: ShopDetailInfoRowWidget(model: widget.model),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverToBoxAdapter(
            child: ShopDetailVerifiedWidget(model: widget.model),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverToBoxAdapter(
            child: ShopDetailCategoriesWidget(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverToBoxAdapter(
            child: ShopDetailAboutWidget(model: widget.model),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverToBoxAdapter(
            child: ShopDetailDetailsWidget(model: widget.model),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          SliverToBoxAdapter(
            child: ShopDetailCtaWidget(model: widget.model),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text('Harytlar', style: textStyles.s16w600clBlack),
            ),
          ),

           ShopDetailProductsWidget(
            productBloc: _productBloc,
            products: _products,
            hasMore: _hasMore,
            isLoadingMore: _isLoadingMore,
          ),
        ],
      ),
    );
  }
}