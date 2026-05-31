import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/helpers.dart';
import 'package:mbium_mobile_client/feature/shops/bloc/shop_bloc.dart';
import 'package:mbium_mobile_client/feature/shops/data/shop_repository.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_filter_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/top_products/presentation/widget/top_seller_card.dart';
import 'package:mbium_mobile_client/feature/top_products/presentation/widget/top_sellers_header_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../generated/l10n.dart';

class SatuwLiderleriTabWidget extends StatefulWidget {
  const SatuwLiderleriTabWidget({super.key});

  @override
  State<SatuwLiderleriTabWidget> createState() =>
      _SatuwLiderleriTabWidgetState();
}

class _SatuwLiderleriTabWidgetState extends State<SatuwLiderleriTabWidget> {
  final _scrollController = ScrollController();
  late ShopBloc _shopBloc;

  final List<ShopModel> _shops = [];

  @override
  void initState() {
    super.initState();
    _shopBloc = ShopBloc(repository: context.read<ShopRepository>());
    _shopBloc.add(const LoadShops(ShopFilterModel()));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _shopBloc.add(const LoadMoreShops());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final theme = Theme.of(context);
    return BlocConsumer<ShopBloc, ShopState>(
      bloc: _shopBloc,
      listener: (context, state) {
        if (state is ShopLoading) {
          _shops.clear();
        }

        if (state is ShopError) {
          MyHelpers.showMessage(
            localization.nasazlyk_yuze_cykdy,
            Colors.red,
            context,
          );
        }

        if (state is ShopLoaded) {
          _shops.addAll(state.shops);
        }
      },
      builder: (context, state) {
        if (state is ShopLoading) {
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: _buildShopShimmer(),
                  ),
                  childCount: 6,
                ),
              ),
            ],
          );
        }

        final isLoadingMore = state is ShopLoaded && state.isLoadingMore;
        final itemCount = _shops.length + (isLoadingMore ? 1 : 0);

        return CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: Text(
                  localization.top_satyjylar,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 2,
                ),
                child: TopSellersHeaderWidget(),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index < _shops.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 2,
                    ),
                    child: TopSellerCard(shopModel: _shops[index]),
                  );
                }
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: _buildShopShimmer(),
                );
              }, childCount: itemCount),
            ),
          ],
        );
      },
    );
  }

  Container _buildShopShimmer() {
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
