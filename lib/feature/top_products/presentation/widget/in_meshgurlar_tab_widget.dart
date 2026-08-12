import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/mason_grid_item.dart';

class InMeshgurlarTabWidget extends StatefulWidget {
  const InMeshgurlarTabWidget({super.key});

  @override
  State<InMeshgurlarTabWidget> createState() => _InMeshgurlarTabWidgetState();
}

class _InMeshgurlarTabWidgetState extends State<InMeshgurlarTabWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts(FilterModel(limit: 10)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProductError) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.errorRed, fontSize: 12),
            ),
          );
        }

        if (state is ProductLoaded) {
          final products = state.products;
          if (products.isEmpty) return const SizedBox.shrink();

          return Padding(
            padding: const EdgeInsets.all(8),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, i) =>
                  ProductMassonGridItem(product: products[i]),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
