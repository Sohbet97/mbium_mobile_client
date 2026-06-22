import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';
import 'package:shimmer/shimmer.dart';

class ShopDetailProductsWidget extends StatefulWidget {
  final ProductBloc productBloc;
  final List<ProductModel> products;
  final bool hasMore;

  const ShopDetailProductsWidget({
    super.key,
    required this.productBloc,
    required this.products,
    required this.hasMore,
  });

  @override
  State<ShopDetailProductsWidget> createState() =>
      _ShopDetailProductsWidgetState();
}

class _ShopDetailProductsWidgetState extends State<ShopDetailProductsWidget> {
  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    if (widget.products.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 1,
      crossAxisSpacing: 1,
      childCount: widget.products.length + (widget.hasMore ? 2 : 0),
      itemBuilder: (context, index) {
        if (index < widget.products.length) {
          return ProductMassonGridItem(product: widget.products[index]);
        }
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.surface,
          highlightColor: AppColors.lightBg,
          child: Container(
            height: 200,
            color: Theme.of(context).colorScheme.surface,
          ),
        );
      },
    );
  }
}