import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ShopsHorizontalListWidget extends StatefulWidget {
  const ShopsHorizontalListWidget({super.key});

  @override
  State<ShopsHorizontalListWidget> createState() =>
      _ShopsHorizontalListWidgetState();
}

class _ShopsHorizontalListWidgetState
    extends State<ShopsHorizontalListWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts(FilterModel(limit: 10)));
  }

  String _getImageUrl(ProductModel product) {
    if (product.productMedia.isNotEmpty) {
      final media = product.productMedia.first;
      if (media is Map && media['url'] != null) {
        return media['url'].toString();
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SizedBox(
            height: 160,
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

          return SizedBox(
            height: 160,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final product = products[i];
                final imageUrl = _getImageUrl(product);

                return GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: 100,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _placeholder(context),
                                )
                              : _placeholder(context),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${product.price.toStringAsFixed(0)} ${product.currency}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        Text(
                          product.name,
                          style: textStyles.s13w600clBlack.copyWith(
                              fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: 100,
      height: 110,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textLightGrey,
      ),
    );
  }
}