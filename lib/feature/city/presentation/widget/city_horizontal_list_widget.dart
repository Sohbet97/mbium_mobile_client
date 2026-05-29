import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_horizontal_item.dart';
import 'package:shimmer/shimmer.dart';

class CityHorizontalListWidget extends StatelessWidget {
  final ProductBloc productBloc;
  final ScrollController scrollController;
  final List<ProductModel> products;

  const CityHorizontalListWidget({
    super.key,
    required this.productBloc,
    required this.scrollController,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      bloc: productBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (products.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 180,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: products.length +
                (state is ProductLoaded && state.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < products.length) {
                return ProductHorizontalItem(
                  productModel: products[index],
                  width: 120,
                );
              }
              return Shimmer.fromColors(
                baseColor: Theme.of(context).colorScheme.surface,
                highlightColor: AppColors.lightBg,
                child: Container(
                  height: 90,
                  width: 110,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}