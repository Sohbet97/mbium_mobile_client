import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_horizontal_item.dart';
import 'package:mbium_mobile_client/feature/shops/bloc/shop_bloc.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_banner_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_category_tabs_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_filter_chips_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_horizontal_list_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_menu_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_ondabaryjy_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_section_header_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../generated/l10n.dart';
import '../../../products/data/product_repository.dart';
import '../../data/shop_repository.dart';
import '../../model/shop_filter_model.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _productController = ScrollController();
  late ShopBloc _shopBloc;
  late ProductBloc _productBloc;

  FilterModel _productFilter = FilterModel();

  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _shopBloc = ShopBloc(repository: context.read<ShopRepository>());
    _shopBloc.add(const LoadShops(ShopFilterModel()));
    _productBloc = ProductBloc(repository: context.read<ProductRepository>());
    _scrollController.addListener(_onScroll);
    _productBloc.add(LoadProducts(_productFilter));
    _productController.addListener(_onScrollProduct);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _productController.removeListener(_onScrollProduct);
    _productBloc.close();

    super.dispose();
  }

  void _onScrollProduct() {
    if (_productController.position.pixels >=
        _productController.position.maxScrollExtent - 200) {
      _productBloc.add(LoadMoreProducts());
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _shopBloc.add(const LoadMoreShops());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchWidget(
                  controller: _searchController,
                  onTapPhoto: () {},
                  onTapAudio: () {},
                  onTapAi: () {},
                  onSubmit: () {},
                ),
              ),
              const SizedBox(height: 10),
              ShopsCategoryTabsWidget(onCategorySelected: (index) {}),
              const SizedBox(height: 16),
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const ShopsMenuWidget(),
              const SizedBox(height: 16),

              BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is ProductLoaded) {
                    _products.addAll(state.products);
                  }
                },
                builder: (context, state) {
                  if (state is ProductError) {
                    return SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 120,
                    child: ListView.builder(
                      controller: _productController,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          _products.length +
                          (state is ProductLoaded && state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < _products.length) {
                          final product = _products[index];
                          return ProductHorizontalItem(productModel: product);
                        } else {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: _buildShimmerEfects(),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              // const ShopsHorizontalListWidget(),
              const SizedBox(height: 16),
              ShopsSectionHeaderWidget(
                title: l10n.ondabaryjy_ondurijiler,
                onSeeAll: null,
              ),
              const SizedBox(height: 10),
              // const ShopsOndabaryjyWidget(),
              const SizedBox(height: 16),
              // const ShopsFilterChipsWidget(),
              const SizedBox(height: 16),
              ShopsBannerWidget(
                shopName: l10n.balkan_lale_shop_name,
                description: l10n.balkan_lale_shop_desc,
                onTap: () {},
              ),
              const SizedBox(height: 16),
              const ShopsHorizontalListWidget(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildShimmerEfects() {
    return Container(
      height: 90,
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
