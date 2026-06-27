import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/my_error_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/bloc/recently/recently_viewed_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/product_detail_data_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ProductBloc _productBloc;
  @override
  void initState() {
    super.initState();
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _productBloc.add(GetProductDetailEvent(id: widget.product.id));
    context.read<RecentlyViewedBloc>().add(AddRecentlyViewed(widget.product));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      bloc: _productBloc,
      buildWhen: (previous, current) =>
          current is GetProductDetailError ||
          current is GetProductDetailProgress ||
          current is GetProductDetailSuccess,
      builder: (context, state) {
        if (state is GetProductDetailProgress) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (state is GetProductDetailError) {
          return Scaffold(
            body: MyErrorWidget(
              error: state.errorMessage,
              onTap: () {
                context.read<ProductBloc>().add(
                  GetProductDetailEvent(id: widget.product.id),
                );
              },
            ),
          );
        }

        if (state is GetProductDetailSuccess) {
          return ProductDetailDataScreen(
            model: state.detailModel,
            litleProductModel: widget.product,
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
