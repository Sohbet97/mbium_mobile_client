import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_alibaba_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_empty_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_promo_banner_widget.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/favorite_bloc.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

import '../../../../core/constants/my_empty_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../category/bloc/category_bloc.dart';
import '../../../products/bloc/product_bloc.dart';
import '../../../products/models/filter_model.dart';
import '../../../products/presentation/widgets/mason_grid_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _scrollController = ScrollController();
  FilterModel _filter = FilterModel();
  late ProductBloc _productBloc;
  late CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
      const LoadCategoriesEvent(isRefresh: false),
    );
    _productBloc = context.read<ProductBloc>()..add(LoadProducts(_filter));
    _scrollController.addListener(_onScroll);
    _cartBloc = context.read<CartBloc>()..add(const LoadCartEvent());
    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(const LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.sebet,
                        style: textStyles.s16w600clBlack.copyWith(fontSize: 20),
                      ),
                      const SizedBox(width: 4),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final itemCount = state is CartLoaded
                              ? state.itemCount
                              : 0;
                          return Text(
                            '($itemCount)',
                            style: textStyles.s16w600clBlack.copyWith(
                              fontSize: 20,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),

                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 14,
                              color: AppColors.lightTextSecondary,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              l10n.us_a_eltip_bermek,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.lightTextSecondary,
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 11,
                              color: AppColors.lightTextSecondary,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      BlocBuilder<FavoriteBloc, FavoriteState>(
                        builder: (context, state) {
                          final count = state is FavoriteLoaded
                              ? state.favorites.length
                              : 0;
                          return Badge(
                            isLabelVisible: count > 0,
                            label: Text(
                              count.toString(),

                              style: const TextStyle(fontSize: 6),
                            ),
                            child: const Icon(
                              Icons.favorite_border_outlined,
                              color: AppColors.lightTextSecondary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const CartPromoBannerWidget(),
                const SizedBox(height: 16),

                const CartEmptyWidget(),
                const SizedBox(height: 16),

                const CartAlibabaWidget(),
                const SizedBox(height: 16),
              ],
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
                    child: MyEmptyWidget(
                      emptyText: S.of(context).product_empty,
                    ),
                  );
                }

                return SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductMassonGridItem(product: product);
                  },
                  childCount: products.length,
                );
              }
              return SliverToBoxAdapter();
            },
          ),
        ],
      ),
    );
  }
}
