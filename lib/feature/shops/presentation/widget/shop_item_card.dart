import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_horizontal_item.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_banner_widget.dart';

import '../../../products/data/product_repository.dart';
import '../../../products/models/filter_model.dart';

class ShopItemCard extends StatefulWidget {
  const ShopItemCard({
    super.key,
    required this.shopModel,
    required this.isShowProducts,
  });
  final ShopModel shopModel;
  final bool isShowProducts;
  @override
  State<ShopItemCard> createState() => _ShopItemCardState();
}

class _ShopItemCardState extends State<ShopItemCard> {
  late ProductBloc _productBloc;
  final List<ProductModel> _products = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.isShowProducts) {
      _productBloc = ProductBloc(repository: context.read<ProductRepository>());
      _productBloc.add(LoadProducts(FilterModel(shopId: widget.shopModel.id)));
      _scrollController.addListener(_onScrool);
    }
  }

  void _onScrool() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isShow = widget.isShowProducts;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ShopsBannerWidget(
            shop: widget.shopModel,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/shopDetail',
                arguments: widget.shopModel,
              );
            },
          ),

          if (isShow)
            BlocConsumer<ProductBloc, ProductState>(
              bloc: _productBloc,
              listener: (context, state) {
                if (state is ProductLoaded) {
                  _products.addAll(state.products);
                }

                if (state is ProductError) {}
              },
              builder: (context, state) {
                return _products.isEmpty
                    ? SizedBox.shrink()
                    : SizedBox(
                        height: 180,
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: _products.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ProductHorizontalItem(
                              productModel: _products[index],
                              width: 120,
                            );
                          },
                        ),
                      );
              },
            ),
        ],
      ),
    );
  }
}
