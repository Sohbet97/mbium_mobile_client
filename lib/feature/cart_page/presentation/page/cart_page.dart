import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/cart_page/models/cart_model.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_alibaba_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_empty_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_item_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_promo_banner_widget.dart';
import 'package:mbium_mobile_client/feature/favorite/bloc/favorite_bloc.dart';
import 'package:mbium_mobile_client/feature/myMbium/bloc/address_bloc.dart';
import 'package:mbium_mobile_client/feature/myMbium/models/address_model.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/addresses/widgets/address_form_sheet.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

import '../../../../core/constants/my_empty_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../category/bloc/category_bloc.dart';
import '../../../products/bloc/product_bloc.dart';
import '../../../products/models/filter_model.dart';
import '../../../products/presentation/widgets/mason_grid_item.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _scrollController = ScrollController();
  final FilterModel _filter = FilterModel();
  late ProductBloc _productBloc;
  AddressModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(
      const LoadCategoriesEvent(isRefresh: false),
    );
    _productBloc = context.read<ProductBloc>()..add(LoadProducts(_filter));
    _scrollController.addListener(_onScroll);
    context.read<CartBloc>().add(const LoadCartEvent());
    context.read<FavoriteBloc>().add(LoadFavorites());
    context.read<AddressBloc>().add(LoadAddressesEvent());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _productBloc.add(const LoadMoreProducts());
    }
  }

  void _onAddressesLoaded(List<AddressModel> addresses) {
    if (_selectedAddress != null || addresses.isEmpty) return;
    final selected = addresses.where((a) => a.isDefault).isNotEmpty
        ? addresses.firstWhere((a) => a.isDefault)
        : addresses.first;
    // Called from a bloc listener during build — defer the setState.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedAddress == null) {
        setState(() => _selectedAddress = selected);
      }
    });
  }

  void _pickAddress(List<AddressModel> addresses) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              S.of(context).addresses,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const Divider(),
            ...addresses.map(
              (a) => ListTile(
                leading: Icon(
                  a.id == _selectedAddress?.id
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.primaryGreen,
                ),
                title: Text(a.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(a.address),
                onTap: () {
                  setState(() => _selectedAddress = a);
                  Navigator.of(sheetContext).pop();
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add, color: AppColors.primaryGreen),
              title: Text(S.of(context).address_add),
              onTap: () {
                Navigator.of(sheetContext).pop();
                AddressFormSheet.show(context);
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final loaded = state is CartLoaded ? state : null;
          final totalPrice = loaded?.totalPrice ?? 0.0;
          final currency = loaded?.items.isNotEmpty == true
              ? loaded!.items.first.product.currency
              : 'TMT';
          final hasItems = loaded != null && loaded.items.isNotEmpty;

          return !hasItems
              ? SizedBox.shrink()
              : GestureDetector(
                  onTap: hasItems
                      ? () {
                          Navigator.pushNamed(context, '/sargytEt');
                        }
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primaryColor.withOpacity(0.7),
                          theme.primaryColor.withOpacity(0.9),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 5,
                      bottom: MediaQuery.of(context).padding.bottom + 5,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: true,
                          checkColor: theme.primaryColor,
                          fillColor: WidgetStatePropertyAll(Colors.white),
                          activeColor: AppColors.primaryGreen,
                          onChanged: (value) {},
                        ),
                        Text(
                          l10n.ahlisi,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        if (hasItems) ...[
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  l10n.jemi,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${totalPrice.toStringAsFixed(2)} $currency',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_right, color: Colors.white),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
        },
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          l10n.sebet,
                          style: textStyles.s16w600clBlack.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 4),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            final itemCount = state is CartLoaded
                                ? state.itemCount
                                : 0;
                            return Text(
                              '($itemCount)',
                              style: textStyles.s16w600clBlack.copyWith(
                                fontSize: 20,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),

                        BlocConsumer<AddressBloc, AddressState>(
                          listener: (context, state) {
                            if (state is AddressLoaded) {
                              _onAddressesLoaded(state.addresses);
                            }
                          },
                          builder: (context, state) {
                            final addresses = state is AddressLoaded
                                ? state.addresses
                                : const <AddressModel>[];
                            return GestureDetector(
                              onTap: addresses.isEmpty
                                  ? () => AddressFormSheet.show(context)
                                  : () => _pickAddress(addresses),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    _selectedAddress?.label ??
                                        l10n.us_a_eltip_bermek,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.lightTextSecondary,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 11,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Spacer(),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/favorite');
                          },
                          child: BlocBuilder<FavoriteBloc, FavoriteState>(
                            builder: (context, state) {
                              final count = state is FavoriteLoaded
                                  ? state.favorites.length
                                  : 0;
                              return Badge(
                                isLabelVisible: count > 0,
                                label: Text(
                                  count.toString(),
                                  style: const TextStyle(fontSize: 6),
                                ),
                                child: const Icon(
                                  Icons.favorite_border_outlined,
                                  color: AppColors.lightTextSecondary,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CartPromoBannerWidget(),
                  const SizedBox(height: 16),

                  BlocBuilder<CartBloc, CartState>(
                    builder: (context, state) {
                      final products = state is CartLoaded
                          ? state.items
                          : <CartModel>[];
                      if (products.isEmpty) {
                        return const CartEmptyWidget();
                      }

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: products
                              .map((item) => CartItemWidget(cartModel: item))
                              .toList(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  const CartAlibabaWidget(),
                  const SizedBox(height: 16),
                ],
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

                if (state is ProductLoaded) {
                  final products = state.products;
                  if (products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: MyEmptyWidget(
                        emptyText: S.of(context).product_empty,
                      ),
                    );
                  }

                  return SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductMassonGridItem(product: product);
                    },
                    childCount: products.length,
                  );
                }
                return SliverToBoxAdapter();
              },
            ),
          ],
        ),
      ),
    );
  }
}
