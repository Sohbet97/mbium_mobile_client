import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/Section_header_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';

/// A masonry grid of other products from the same category, shown further
/// down the product page. Fetches quietly and collapses to nothing on error
/// or an empty category — this is a secondary discovery aid, not core
/// content.
class ProductDetailCategoryProductsWidget extends StatelessWidget {
  final int categoryId;
  final int excludeProductId;
  final String? categoryName;
  final String title;
  final FilterModel filterModel;

  const ProductDetailCategoryProductsWidget({
    super.key,
    required this.categoryId,
    required this.excludeProductId,
    this.categoryName,
    required this.title,
    required this.filterModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductBloc(repository: context.read<ProductRepository>())
            ..add(LoadProducts(filterModel)),
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is! ProductLoaded) return const SizedBox.shrink();

          final products = state.products
              .where((p) => p.id != excludeProductId)
              .toList();
          if (products.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeaderWidget(title: title, subtitle: categoryName),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  itemBuilder: (context, index) =>
                      ProductMassonGridItem(product: products[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
