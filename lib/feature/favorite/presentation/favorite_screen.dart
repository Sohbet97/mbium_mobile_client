import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

import '../../products/presentation/widgets/mason_grid_item.dart';
import '../bloc/favorite_bloc.dart';
import '../bloc/shop_favorite_bloc.dart';
import 'shop_favorite_list_item.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localization.favorites),
          bottom: TabBar(
            tabs: [
              Tab(text: localization.products),
              Tab(text: localization.ondurijiler),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state is FavoriteLoaded) {
                  if (state.favorites.isEmpty) {
                    return MyEmptyWidget(emptyText: localization.product_empty);
                  }
                  return SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 1,
                          itemBuilder: (context, index) {
                            final product = state.favorites[index];
                            return ProductMassonGridItem(product: product);
                          },
                          childCount: state.favorites.length,
                        ),
                      ],
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
            BlocBuilder<ShopFavoriteBloc, ShopFavoriteState>(
              builder: (context, state) {
                if (state is ShopFavoriteLoaded) {
                  if (state.favorites.isEmpty) {
                    return MyEmptyWidget(emptyText: localization.shop_empty);
                  }
                  return SafeArea(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: state.favorites.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final shop = state.favorites[index];
                        return ShopFavoriteListItem(shop: shop);
                      },
                    ),
                  );
                }

                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
