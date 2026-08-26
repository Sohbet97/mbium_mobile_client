import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/feature/banners/bloc/banner_bloc.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/category_banner_strip_widget.dart';
import 'package:mbium_mobile_client/feature/banners/presentation/category_top_banner_widget.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/category_drilldown_sheet.dart';
import 'package:mbium_mobile_client/feature/category/presentation/widgets/category_grid_item_widget.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/list_product_item.dart';

import '../../../../generated/l10n.dart';

const _gridLimit = 14;

class CategoryFocusPanelWidget extends StatefulWidget {
  const CategoryFocusPanelWidget({
    super.key,
    required this.focus,
    required this.languageCode,
    required this.scrollController,
    required this.onChildTap,
    required this.onOpenDetail,
  });

  final CategoryModel focus;
  final String languageCode;
  final ScrollController scrollController;

  /// Tap on a real subcategory tile in the random grid.
  final ValueChanged<CategoryModel> onChildTap;

  /// Tap on a level-3 item (or a childless level-2 item) inside the
  /// drilldown sheet opened from the "added" tile.
  final ValueChanged<CategoryModel> onOpenDetail;

  @override
  State<CategoryFocusPanelWidget> createState() =>
      _CategoryFocusPanelWidgetState();
}

class _CategoryFocusPanelWidgetState extends State<CategoryFocusPanelWidget> {
  late List<CategoryModel> _gridItems;

  @override
  void initState() {
    super.initState();
    _gridItems = _pickRandomGrandchildren();
  }

  @override
  void didUpdateWidget(covariant CategoryFocusPanelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focus.id != widget.focus.id) {
      setState(() => _gridItems = _pickRandomGrandchildren());
    }
  }

  // Grid-de 3-nji derejäni (agtyklar) görkezýäris — 2-nji derejе diňe
  // aşaky "dragawable" sheet-iň içinde görkezilýär.
  List<CategoryModel> _pickRandomGrandchildren() {
    final grandchildren =
        widget.focus.children.expand((child) => child.children).toList()
          ..shuffle();
    return grandchildren.take(_gridLimit).toList();
  }

  void _openDrilldownSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => CategoryDrilldownSheet(
        levelTwoCategories: widget.focus.children,
        onCategorySelected: (category) {
          Navigator.of(sheetContext).pop();
          widget.onOpenDetail(category);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final focus = widget.focus;
    final gridItems = _gridItems;
    final showAddedTile = focus.children.isNotEmpty;

    final bannerState = context.watch<BannerBloc>().state;
    final hasCategoryBanners =
        bannerState is BannerLoaded &&
        bannerState.bannersByType('category').any((b) => b.isCurrentlyActive);

    return Container(
      color: Colors.white,
      child: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          if (hasCategoryBanners)
            SliverToBoxAdapter(
              child: CategoryTopBannerWidget(categoryId: focus.id),
            ),

          if (gridItems.isNotEmpty || showAddedTile)
            SliverGrid.builder(
              itemCount: gridItems.length + (showAddedTile ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 100,
              ),
              itemBuilder: (context, index) {
                if (showAddedTile && index == gridItems.length) {
                  return Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: GestureDetector(
                      onTap: _openDrilldownSheet,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.bonusCoinGrey.withValues(
                          alpha: 0.4,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.category_outlined, color: Colors.white),
                            Text(
                              S.of(context).ahlisi,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                final model = gridItems[index];
                return CategoryGridItemWidget(
                  model: model,
                  languageCode: widget.languageCode,
                  onTap: () => widget.onChildTap(model),
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
  for (
    var chunkStart = 0;
    chunkStart < products.length;
    chunkStart += pageSize
  ) {
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
