import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/category/bloc/category_bloc.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/Category_tabs_widget.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../../products/bloc/product_bloc.dart';
import '../../../products/models/filter_model.dart';
import '../../../products/presentation/widgets/mason_grid_item.dart';
import '../widget/chats_empty_widget.dart';
import '../widget/chats_filter_widget.dart';
import '../widget/chats_notification_banner_widget.dart';
import '../widget/chats_promo_widget.dart';
import '../widget/chats_search_widget.dart';
import '../widget/chats_tab_widget.dart';

import '../../../../generated/l10n.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late ProductBloc _productBloc;
  FilterModel _filter = FilterModel();
  final List<ProductModel> _products = [];
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
      const LoadCategoriesEvent(isRefresh: false),
    );
    _productBloc = context.read<ProductBloc>();
    _productBloc.add(LoadProducts(_filter));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(LoadProducts(_filter));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.chats,
                        style: textStyles.s16w600clBlack.copyWith(fontSize: 20),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.textLightGrey,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.more_horiz,
                        color: AppColors.lightTextSecondary,
                      ),
                    ],
                  ),
                ),
                const ChatsNotificationBannerWidget(),
                const ChatsTabWidget(),
                const SizedBox(height: 16),
                ChatsSearchWidget(controller: _searchController),
                const SizedBox(height: 12),
                const ChatsFilterWidget(),
                const SizedBox(height: 8),
                const ChatsEmptyWidget(),
                const ChatsPromoWidget(),
                const SizedBox(height: 20),

                CategoryTabsWidget(
                  onCategorySelected: (id) {
                    _filter = FilterModel(categoryId: id == 0 ? null : id);
                    _products.clear();
                    _productBloc.add(LoadProducts(_filter));
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),

          BlocConsumer<ProductBloc, ProductState>(
            bloc: _productBloc,
            listener: (context, state) {
              if (state is ProductLoaded) {
                _products.addAll(state.products);
              }

              if (state is ProductError) {
                MyHelpers.showMessage(
                  S.of(context).nasazlyk_yuze_cykdy,
                  Colors.red,
                  context,
                );
              }
            },
            builder: (context, state) {
              if (state is ProductLoading && _products.isEmpty) {
                return SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) => const _ShimmerEfect(),
                );
              }
              if (_products.isEmpty) {
                return SliverToBoxAdapter(
                  child: MyEmptyWidget(emptyText: S.of(context).product_empty),
                );
              }
              return SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                itemBuilder: (context, index) {
                  if (index >= _products.length) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final product = _products[index];
                  return ProductMassonGridItem(product: product);
                },
                childCount: state is ProductLoaded && state.isLoadingMore
                    ? _products.length + 1
                    : _products.length,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ShimmerEfect extends StatelessWidget {
  const _ShimmerEfect();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
