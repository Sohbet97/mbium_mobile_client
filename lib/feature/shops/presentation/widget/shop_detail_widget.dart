import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_app_bar_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_header_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_tab_bar_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_about_tab_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_products_tab_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_reviews_tab_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_fixed_header_delegate.dart';

class ShopDetailWidget extends StatefulWidget {
  const ShopDetailWidget({super.key, required this.model});
  final ShopDetailModel model;

  @override
  State<ShopDetailWidget> createState() => _ShopDetailWidgetState();
}

class _ShopDetailWidgetState extends State<ShopDetailWidget>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final ProductBloc _productBloc;
  final ScrollController _productsScrollController = ScrollController();
  List<ProductModel> _products = [];
  bool _hasMore = false;
  bool _isLoadingMore = false;
  bool _isAppBarCollapsed = false;

  static const double _headerScrollThreshold = 170;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _productBloc.add(LoadProducts(FilterModel(shopId: widget.model.id)));
    _productsScrollController.addListener(_onProductsScroll);
  }

  void _onProductsScroll() {
    if (_productsScrollController.position.pixels >=
        _productsScrollController.position.maxScrollExtent - 200) {
      _productBloc.add(LoadMoreProducts());
    }
  }

  bool _onOuterScroll(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    final offset = notification.metrics.pixels;
    final collapsed = offset >= _headerScrollThreshold;
    if (collapsed != _isAppBarCollapsed) {
      setState(() => _isAppBarCollapsed = collapsed);
    }
    return false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _productsScrollController.dispose();
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      bloc: _productBloc,
      listener: (context, state) {
        if (state is ProductLoaded) {
          setState(() {
            _products = state.products;
            _hasMore = state.hasMore;
            _isLoadingMore = false;
          });
        }
        if (state is ProductLoading) {
          setState(() => _isLoadingMore = true);
        }
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _onOuterScroll,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                pinned: true,
                delegate: ShopDetailFixedHeaderDelegate(
                  height: 56,
                  child: ShopDetailAppBarWidget(
                    model: widget.model,
                    isCollapsed: _isAppBarCollapsed,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ShopDetailHeaderWidget(model: widget.model),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: ShopDetailFixedHeaderDelegate(
                  height: 48,
                  child: ShopDetailTabBarWidget(controller: _tabController),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              ShopDetailAboutTabWidget(model: widget.model),
              ShopDetailProductsTabWidget(
                model: widget.model,
                productBloc: _productBloc,
                scrollController: _productsScrollController,
                products: _products,
                hasMore: _hasMore,
                isLoadingMore: _isLoadingMore,
              ),
              const ShopDetailReviewsTabWidget(),
            ],
          ),
        ),
      ),
    );
  }
}