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
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_faq_tab_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_fixed_header_delegate.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_video_widget.dart';

class ShopDetailWidget extends StatefulWidget {
  const ShopDetailWidget({super.key, required this.model});
  final ShopDetailModel model;

  @override
  State<ShopDetailWidget> createState() => _ShopDetailWidgetState();
}

class _ShopDetailWidgetState extends State<ShopDetailWidget>
    with TickerProviderStateMixin {
  static const _videoWidgetSize = Size(120, 180);

  late final TabController _tabController;
  late final ProductBloc _productBloc;
  List<ProductModel> _products = [];
  bool _hasMore = false;
  bool _isLoadingMore = false;
  Offset? _videoPosition;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _productBloc.add(LoadProducts(FilterModel(shopId: widget.model.id)));
  }

  void _loadMoreProducts() {
    _productBloc.add(LoadMoreProducts());
  }

  void _onVideoDragUpdate(DragUpdateDetails details, Size screenSize) {
    final current =
        _videoPosition ??
        Offset(screenSize.width - _videoWidgetSize.width - 10, 5);
    final next = current + details.delta;
    setState(() {
      _videoPosition = Offset(
        next.dx.clamp(0, screenSize.width - _videoWidgetSize.width),
        next.dy.clamp(0, screenSize.height - _videoWidgetSize.height),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final videoPosition =
        _videoPosition ??
        Offset(screenSize.width - _videoWidgetSize.width - 10, 5);

    return Stack(
      children: [
        BlocListener<ProductBloc, ProductState>(
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
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: ShopDetailFixedHeaderDelegate(
                    height: 56,
                    child: ShopDetailAppBarWidget(model: widget.model),
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
                  products: _products,
                  hasMore: _hasMore,
                  isLoadingMore: _isLoadingMore,
                  onLoadMore: _loadMoreProducts,
                ),
                ShopDetailFaqTabWidget(model: widget.model),
              ],
            ),
          ),
        ),
        Positioned(
          left: videoPosition.dx,
          top: videoPosition.dy,
          child: GestureDetector(
            onPanUpdate: (details) => _onVideoDragUpdate(details, screenSize),
            child: ShopDetailVideoWidget(model: widget.model),
          ),
        ),
      ],
    );
  }
}
