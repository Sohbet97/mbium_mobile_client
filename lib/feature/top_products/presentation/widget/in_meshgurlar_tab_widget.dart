import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

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

  String _getImageUrl(ProductModel product) {
    return product.primaryThumbnailUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

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
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, i) {
                final product = products[i];
                final imageUrl = _getImageUrl(product);

                return GestureDetector(
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _placeholder(context),
                                )
                              : _placeholder(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.name,
                        style: textStyles.s13w600clBlack.copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${product.price.toStringAsFixed(0)} ${product.currency}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
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
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textLightGrey,
      ),
    );
  }
}
