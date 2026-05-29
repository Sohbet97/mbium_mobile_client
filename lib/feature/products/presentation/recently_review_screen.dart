import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/recently/recently_viewed_bloc.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';

import '../../../generated/l10n.dart';

class RecentlyReviewScreen extends StatefulWidget {
  const RecentlyReviewScreen({super.key});

  @override
  State<RecentlyReviewScreen> createState() => _RecentlyReviewScreenState();
}

class _RecentlyReviewScreenState extends State<RecentlyReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RecentlyViewedBloc>().add(LoadRecentlyViewed());
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localization.gorulen_harytlar)),
      body: BlocBuilder<RecentlyViewedBloc, RecentlyViewedState>(
        builder: (context, state) {
          if (state is RecentlyViewedLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return Center(
                child: MyEmptyWidget(emptyText: localization.product_empty),
              );
            }

            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductMassonGridItem(product: product);
                    },
                    childCount: products.length,
                  ),
                ],
              ),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
