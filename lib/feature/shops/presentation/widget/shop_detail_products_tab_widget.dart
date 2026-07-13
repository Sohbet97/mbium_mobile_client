import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/product_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_products_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailProductsTabWidget extends StatefulWidget {
  final ShopDetailModel model;
  final ProductBloc productBloc;
  final List<ProductModel> products;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  const ShopDetailProductsTabWidget({
    super.key,
    required this.model,
    required this.productBloc,
    required this.products,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  @override
  State<ShopDetailProductsTabWidget> createState() =>
      _ShopDetailProductsTabWidgetState();
}

class _ShopDetailProductsTabWidgetState
    extends State<ShopDetailProductsTabWidget> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _currentSort;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _dispatchFilter() {
    final query = _searchController.text.trim();
    widget.productBloc.add(
      LoadProducts(
        FilterModel(
          shopId: widget.model.id,
          text: query.isEmpty ? null : query,
          sort: _currentSort,
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _dispatchFilter);
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 200) {
      widget.onLoadMore();
    }
    return false;
  }

  Future<void> _makeCall() async {
    if (widget.model.phone == null || widget.model.phone!.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: widget.model.phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _sendMessage() async {
    if (widget.model.phone == null || widget.model.phone!.isEmpty) return;
    final uri = Uri(scheme: 'sms', path: widget.model.phone);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openSortSheet() async {
    final l10n = S.of(context);
    final result = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        final textStyles = sheetContext.appTextStyles;
        Widget option(String label, String? value, IconData icon) {
          final selected = _currentSort == value;
          return ListTile(
            leading: Icon(icon,
                color: selected ? AppColors.primaryGreen : AppColors.lightTextSecondary),
            title: Text(
              label,
              style: selected
                  ? textStyles.s13w600clBlack.copyWith(color: AppColors.primaryGreen)
                  : textStyles.s13w600clBlack,
            ),
            trailing: selected
                ? const Icon(Icons.check, color: AppColors.primaryGreen)
                : null,
            onTap: () => Navigator.pop(sheetContext, value),
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(l10n.tertiplemek, style: textStyles.s16w600clBlack),
              const SizedBox(height: 8),
              option(l10n.in_arzan, 'price_asc', Icons.arrow_upward),
              option(l10n.in_gymmat, 'price_desc', Icons.arrow_downward),
              option(l10n.in_taze, 'newest', Icons.fiber_new_outlined),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (result != _currentSort) {
      setState(() => _currentSort = result);
      _dispatchFilter();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final hasActiveSort = _currentSort != null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.navBarGrey),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.lightTextSecondary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          onSubmitted: (_) {
                            _debounce?.cancel();
                            _dispatchFilter();
                          },
                          decoration: InputDecoration(
                            hintText: l10n.haryt_gozle,
                            hintStyle: const TextStyle(
                                fontSize: 13, color: AppColors.lightTextSecondary),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            _debounce?.cancel();
                            _dispatchFilter();
                            setState(() {});
                          },
                          child: const Icon(Icons.close,
                              color: AppColors.lightTextSecondary, size: 18),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _openSortSheet,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: hasActiveSort
                        ? AppColors.primaryGreen.withValues(alpha: 0.1)
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: hasActiveSort ? AppColors.primaryGreen : AppColors.navBarGrey),
                  ),
                  child: Icon(
                    Icons.tune,
                    color: hasActiveSort ? AppColors.primaryGreen : AppColors.lightTextPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${widget.products.length}${widget.hasMore ? '+' : ''} ${l10n.haryt}',
              style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: _onScrollNotification,
                child: CustomScrollView(
                  slivers: [
                    ShopDetailProductsWidget(
                      productBloc: widget.productBloc,
                      products: widget.products,
                      hasMore: widget.hasMore,
                      isLoadingMore: widget.isLoadingMore,
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 70)),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _sendMessage,
                        icon: const Icon(Icons.chat_bubble_outline, size: 16),
                        label: Text(l10n.habarlas),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          foregroundColor: AppColors.primaryGreen,
                          side: const BorderSide(color: AppColors.primaryGreen),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _makeCall,
                        icon: const Icon(Icons.phone_outlined, size: 16),
                        label: Text(l10n.jan_et),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: AppColors.navWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}