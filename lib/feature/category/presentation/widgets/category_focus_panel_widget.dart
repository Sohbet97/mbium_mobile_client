import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/category_banner_strip_widget.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/category_top_banner_widget.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/category_grid_item_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/list_product_item.dart';

import '../../../../generated/l10n.dart';

class CategoryFocusPanelWidget extends StatelessWidget {
  const CategoryFocusPanelWidget({
    super.key,
    required this.focus,
    required this.languageCode,
    required this.scrollController,
    required this.onChildTap,
  });

  final CategoryModel focus;
  final String languageCode;
  final ScrollController scrollController;
  final ValueChanged<CategoryModel> onChildTap;

  @override
  Widget build(BuildContext context) {
    final children = focus.children;
    final bannerState = context.watch<BannerBloc>().state;
    final hasCategoryBanners =
        bannerState is BannerLoaded &&
        bannerState.bannersByType('category').any((b) => b.isCurrentlyActive);

    return Container(
      color: Colors.white,
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          if (hasCategoryBanners)
            SliverToBoxAdapter(
              child: CategoryTopBannerWidget(categoryId: focus.id),
            ),

          if (children.isNotEmpty)
            SliverGrid.builder(
              itemCount: children.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 90,
              ),
              itemBuilder: (context, index) {
                final model = children[index];
                return CategoryGridItemWidget(
                  model: model,
                  languageCode: languageCode,
                  onTap: () => onChildTap(model),
                );
              },
            ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsGeometry.only(
                top: 20,
                left: 10,
                bottom: 3,
              ),
              child: Text(
                S.of(context).sizin_ucin,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: MyLoadingWidget(),
                  ),
                );
              }

              if (state is ProductLoaded) {
                if (state.products.isEmpty) {
                  return SliverToBoxAdapter(
                    child: MyEmptyWidget(
                      emptyText: S.of(context).product_empty,
                    ),
                  );
                }

                final entries = _buildCategoryListEntries(
                  products: state.products,
                  hasCategoryBanners: hasCategoryBanners,
                  pageSize: state.filter.limit,
                );

                return SliverList.builder(
                  itemCount: entries.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == entries.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: MyLoadingWidget(),
                      );
                    }
                    final entry = entries[index];
                    return entry.bannerInsertionIndex != null
                        ? CategoryBannerStripWidget(
                            insertionIndex: entry.bannerInsertionIndex!,
                          )
                        : ListProductItem(model: entry.product!);
                  },
                );
              }

              if (state is ProductError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(state.message),
                    ),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}

List<_CategoryListEntry> _buildCategoryListEntries({
  required List<ProductModel> products,
  required bool hasCategoryBanners,
  required int pageSize,
}) {
  if (pageSize <= 0 || !hasCategoryBanners) {
    return products.map(_CategoryListEntry.product).toList();
  }

  final entries = <_CategoryListEntry>[];
  var insertionIndex = 0;
  for (var chunkStart = 0; chunkStart < products.length; chunkStart += pageSize) {
    entries.add(_CategoryListEntry.bannerStrip(insertionIndex));
    insertionIndex++;

    final chunkEnd = (chunkStart + pageSize).clamp(0, products.length);
    for (var i = chunkStart; i < chunkEnd; i++) {
      entries.add(_CategoryListEntry.product(products[i]));
    }
  }
  return entries;
}

class _CategoryListEntry {
  final ProductModel? product;
  final int? bannerInsertionIndex;

  const _CategoryListEntry.product(this.product) : bannerInsertionIndex = null;

  const _CategoryListEntry.bannerStrip(this.bannerInsertionIndex)
    : product = null;
}
