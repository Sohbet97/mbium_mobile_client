import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/recently/recently_viewed_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_horizontal_item.dart';
import 'package:mbium_mobile_client/feature/shops/bloc/shop_bloc.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_category_tabs_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_filter_chips_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_menu_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../generated/l10n.dart';
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
  late ShopBloc _shopBloc;

  ShopFilterModel _shopFilterModel = ShopFilterModel();

  final List<ShopModel> _shops = [];

  @override
  void initState() {
    super.initState();
    _shopBloc = ShopBloc(repository: context.read<ShopRepository>());
    _shopBloc.add(LoadShops(_shopFilterModel));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _shopBloc.close();

    super.dispose();
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
          child: SearchWidget(controller: _searchController, onSubmit: () {}),
        ),

        const SizedBox(height: 10),
        // Recently-viewed products (below) aren't category-filterable, so
        // this tab bar no longer drives anything — kept for the visual
        // category browsing entry point it still offers elsewhere.
        ShopsCategoryTabsWidget(onCategorySelected: (index) {}),
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

                    BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
                      builder: (context, state) {
                        final products = state is RecentlyViewedLoaded
                            ? state.products
                            : const <ProductModel>[];
                        if (products.isEmpty) return const SizedBox.shrink();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                l10n.on_gorulen_onumler_section,
                                style: context.appTextStyles.s16w600clBlack,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 180,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: products.length,
                                itemBuilder: (context, index) => ProductHorizontalItem(
                                  productModel: products[index],
                                  width: 120,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

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
