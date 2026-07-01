import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_horizontal_item.dart';
import 'package:mbium_mobile_client/feature/shops/bloc/shop_bloc.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_category_tabs_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_filter_chips_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_menu_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../generated/l10n.dart';
import '../../../products/data/product_repository.dart';
import '../../data/shop_repository.dart';
import '../../model/shop_filter_model.dart';
import '../widget/shop_item_card.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _productController = ScrollController();
  late ShopBloc _shopBloc;
  late ProductBloc _productBloc;

  FilterModel _productFilter = FilterModel();
  ShopFilterModel _shopFilterModel = ShopFilterModel();

  final List<ProductModel> _products = [];
  final List<ShopModel> _shops = [];

  @override
  void initState() {
    super.initState();
    _shopBloc = ShopBloc(repository: context.read<ShopRepository>());
    _shopBloc.add(LoadShops(_shopFilterModel));
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _scrollController.addListener(_onScroll);
    _productBloc.add(LoadProducts(_productFilter));
    _productController.addListener(_onScrollProduct);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _productController.removeListener(_onScrollProduct);
    _productBloc.close();

    super.dispose();
  }

  void _onScrollProduct() {
    if (_productController.position.pixels >=
        _productController.position.maxScrollExtent - 200) {
      _productBloc.add(LoadMoreProducts());
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _shopBloc.add(const LoadMoreShops());
    }
  }

  void _resetShops() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    _shopBloc.add(LoadShops(_shopFilterModel));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchWidget(
            controller: _searchController,
            onTapPhoto: () {},
            onTapAudio: () {},
            onTapAi: () {},
            onSubmit: () {},
          ),
        ),

        const SizedBox(height: 10),
        ShopsCategoryTabsWidget(
          onCategorySelected: (index) {
            setState(() {
              _productFilter = FilterModel(categoryId: index);
              _products.clear();
              _productBloc.add(LoadProducts(_productFilter));
            });
          },
        ),
        const SizedBox(height: 10),

        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const ShopsMenuWidget(),
                    const SizedBox(height: 16),

                    BlocConsumer<ProductBloc, ProductState>(
                      bloc: _productBloc,
                      listener: (context, state) {
                        if (state is ProductLoaded) {
                          _products.addAll(state.products);
                        }
                      },
                      builder: (context, state) {
                        if (state is ProductError) {
                          return SizedBox.shrink();
                        }
                        return _products.isEmpty
                            ? SizedBox.shrink()
                            : SizedBox(
                                height: 180,
                                child: ListView.builder(
                                  controller: _productController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      _products.length +
                                      (state is ProductLoaded && state.hasMore
                                          ? 1
                                          : 0),
                                  itemBuilder: (context, index) {
                                    if (index < _products.length) {
                                      final product = _products[index];
                                      return ProductHorizontalItem(
                                        productModel: product,
                                        width: 120,
                                      );
                                    } else {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: _buildShimmerEfects(),
                                      );
                                    }
                                  },
                                ),
                              );
                      },
                    ),

                    // const ShopsHorizontalListWidget(),
                    // ShopsSectionHeaderWidget(
                    //   title: l10n.ondabaryjy_ondurijiler,
                    //   onSeeAll: null,
                    // ),
                    // const ShopsOndabaryjyWidget(),
                    // const ShopsFilterChipsWidget(),
                    const SizedBox(height: 16),
                    ShopsFilterChipsWidget(
                      onTypeSelected: (value) {
                        _shopFilterModel = _shopFilterModel.copyWith(
                          typeId: value,
                        );
                        _resetShops();
                      },
                    ),
                  ],
                ),
              ),

              // SliverList
              BlocConsumer<ShopBloc, ShopState>(
                bloc: _shopBloc,
                listener: (context, state) {
                  if (state is ShopLoading) {
                    _shops.clear();
                  }

                  if (state is ShopError) {
                    MyHelpers.showMessage(
                      l10n.nasazlyk_yuze_cykdy,
                      Colors.red,
                      context,
                    );
                  }

                  if (state is ShopLoaded) {
                    _shops.addAll(state.shops);
                  }
                },
                builder: (context, state) {
                  if (state is ShopLoading) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: _buildShopShimmer(),
                        ),
                        childCount: 6,
                      ),
                    );
                  }

                  final isLoadingMore =
                      state is ShopLoaded && state.isLoadingMore;
                  final itemCount = _shops.length + (isLoadingMore ? 1 : 0);

                  if (_shops.isEmpty && state is ShopLoaded) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35),
                        child: MyEmptyWidget(
                          emptyText: l10n.shop_empty,
                          onTap: () {
                            Navigator.pushNamed(context, '/reg_shop');
                          },
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index < _shops.length) {
                        return ShopItemCard(
                          shopModel: _shops[index],
                          isShowProducts: true,
                        );
                      }
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: _buildShopShimmer(),
                      );
                    }, childCount: itemCount),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildShimmerEfects() {
    return Container(
      height: 90,
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Container _buildShopShimmer() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
