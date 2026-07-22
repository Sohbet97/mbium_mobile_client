import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/constants/my_empty_widget.dart';
import 'package:mbium_mobile_client/core/network/interceptors.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/widgets/loading_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/cart_page/models/cart_model.dart';
import 'package:mbium_mobile_client/feature/myMbium/bloc/address_bloc.dart';
import 'package:mbium_mobile_client/feature/myMbium/models/address_model.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/addresses/widgets/address_form_sheet.dart';
import 'package:mbium_mobile_client/feature/orders/data/order_repository.dart';

import '../../../generated/l10n.dart';

class SargytEtScreen extends StatefulWidget {
  const SargytEtScreen({super.key});

  @override
  State<SargytEtScreen> createState() => _SargytEtScreenState();
}

class _SargytEtScreenState extends State<SargytEtScreen> {
  final _noteController = TextEditingController();
  final _manualAddressController = TextEditingController();
  AddressModel? _selectedAddress;
  bool _useManualAddress = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddressesEvent());
  }

  @override
  void dispose() {
    _noteController.dispose();
    _manualAddressController.dispose();
    super.dispose();
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

  Map<int, List<CartModel>> _groupByShop(List<CartModel> items) {
    final groups = <int, List<CartModel>>{};
    for (final item in items) {
      groups.putIfAbsent(item.product.shopId, () => []).add(item);
    }
    return groups;
  }

  Future<void> _submit(List<CartModel> items) async {
    final deliveryAddress = _useManualAddress
        ? _manualAddressController.text.trim()
        : _selectedAddress?.address ?? '';
    if (deliveryAddress.isEmpty) {
      showGlobalMessage(
        _useManualAddress
            ? 'Eltip bermek salgysyny giriziň'
            : 'Eltip bermek salgysyny saýlaň',
      );
      return;
    }
    if (items.isEmpty || _submitting) return;

    setState(() => _submitting = true);
    final orderRepository = context.read<OrderRepository>();
    final groups = _groupByShop(items);
    final failedShops = <String>[];

    for (final entry in groups.entries) {
      final shopItems = entry.value;
      final payload = {
        'shop_id': entry.key,
        'delivery_address': deliveryAddress,
        'note': _noteController.text,
        'items': shopItems
            .map(
              (i) => {
                'product_id': i.product.id,
                'variant_id': i.variantId ?? 0,
                'variant_size_id': i.variantSizeId ?? 0,
                'quantity': i.quantity,
              },
            )
            .toList(),
      };
      try {
        await orderRepository.createOrders(payload);
      } catch (e) {
        failedShops.add(
          shopItems.first.product.shop?.name ?? 'Shop #${entry.key}',
        );
      }
    }

    if (!mounted) return;
    setState(() => _submitting = false);

    if (failedShops.isEmpty) {
      context.read<CartBloc>().add(const ClearCartEvent());
      showGlobalMessage('Sargyt üstünlikli döredildi', isError: false);
      Navigator.of(context).pushReplacementNamed('/orders');
    } else {
      showGlobalMessage(
        'Sargyt döredilmedi: ${failedShops.join(', ')}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final cartState = context.watch<CartBloc>().state;
    final items = cartState is CartLoaded ? cartState.items : const <CartModel>[];
    final total = cartState is CartLoaded ? cartState.totalPrice : 0.0;
    final currency = items.isNotEmpty ? items.first.product.currency : 'TMT';

    return Scaffold(
      appBar: AppBar(title: Text(localization.sargyt_etmek)),
      body: items.isEmpty
          ? MyEmptyWidget(
              emptyText: localization.sebedinez_bos,
              icon: Icons.shopping_cart_outlined,
            )
          : BlocListener<AddressBloc, AddressState>(
              listener: (context, state) {
                if (state is AddressLoaded) _onAddressesLoaded(state.addresses);
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildAddressSection(),
                  const SizedBox(height: 20),
                  _buildNoteField(),
                  const SizedBox(height: 20),
                  ..._groupByShop(items).entries.map(
                    (entry) => _buildShopGroup(entry.key, entry.value),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _buildBottomBar(items, total, currency),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ChoiceChip(
              label: Text(S.of(context).addresses),
              selected: !_useManualAddress,
              onSelected: (_) => setState(() => _useManualAddress = false),
              selectedColor: AppColors.primaryGreen,
              labelStyle: TextStyle(
                color: !_useManualAddress ? Colors.white : null,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Elde girizmek'),
              selected: _useManualAddress,
              onSelected: (_) => setState(() => _useManualAddress = true),
              selectedColor: AppColors.primaryGreen,
              labelStyle: TextStyle(
                color: _useManualAddress ? Colors.white : null,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _useManualAddress ? _buildManualAddressField() : _buildSavedAddressTile(),
      ],
    );
  }

  Widget _buildManualAddressField() {
    return TextField(
      controller: _manualAddressController,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: S.of(context).address_field_hint,
        prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.primaryGreen),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSavedAddressTile() {
    return BlocBuilder<AddressBloc, AddressState>(
      builder: (context, state) {
        if (state is AddressLoading || state is AddressInitial) {
          return const SizedBox(height: 60, child: MyLoadingWidget());
        }

        final addresses = state is AddressLoaded ? state.addresses : const <AddressModel>[];
        return GestureDetector(
          onTap: addresses.isEmpty
              ? () => AddressFormSheet.show(context)
              : () => _pickAddress(addresses),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, color: AppColors.primaryGreen),
                const SizedBox(width: 10),
                Expanded(
                  child: _selectedAddress != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedAddress!.label,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedAddress!.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: AppColors.lightTextSecondary),
                            ),
                          ],
                        )
                      : Text(
                          S.of(context).address_add,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.lightTextSecondary),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoteField() {
    return TextField(
      controller: _noteController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Bellik (hökman däl)',
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildShopGroup(int shopId, List<CartModel> shopItems) {
    final shopName = shopItems.first.product.shop?.name ?? 'Dükan #$shopId';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront_outlined, size: 18, color: AppColors.primaryGreen),
              const SizedBox(width: 6),
              Text(shopName, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const Divider(height: 20),
          ...shopItems.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.variantLabel != null
                          ? '${item.product.name} (${item.variantLabel})'
                          : item.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text('x${item.quantity}', style: TextStyle(color: AppColors.lightTextSecondary)),
                  const SizedBox(width: 8),
                  Text(
                    '${(item.product.price * item.quantity).toStringAsFixed(2)} ${item.product.currency}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(List<CartModel> items, double total, String currency) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(S.of(context).jemi, style: TextStyle(color: AppColors.lightTextSecondary)),
                    Text(
                      '${total.toStringAsFixed(2)} $currency',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 180,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitting ? null : () => _submit(items),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          S.of(context).sargyt_etmek,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
