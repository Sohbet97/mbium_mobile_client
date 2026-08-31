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
  bool _submitting = false;
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  String _selectedRegionLabel = '';
  final Map<int, String> _shopDeliveryMethods = {};
  String _paymentMethod = 'card_in_shop';

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddressesEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_selectedRegionLabel.isEmpty) {
      _selectedRegionLabel = S.of(context).asgabat_saher_ici;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _manualAddressController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
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
        setState(() {
          _selectedAddress = selected;
          _manualAddressController.text = selected.address;
        });
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
                  setState(() {
                    _selectedAddress = a;
                    _manualAddressController.text = a.address;
                  });
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

  void _openRegionPicker() {
    final l10n = S.of(context);
    final options = [l10n.asgabat_saher_ici, 'Ahal', 'Balkan', 'Daşoguz', 'Lebap', 'Mary'];

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map(
                (o) => ListTile(
                  title: Text(o),
                  onTap: () {
                    setState(() => _selectedRegionLabel = o);
                    Navigator.of(sheetContext).pop();
                  },
                ),
              )
              .toList(),
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
    final localization = S.of(context);
    final deliveryAddress = _manualAddressController.text.trim();
    if (deliveryAddress.isEmpty) {
      showGlobalMessage(localization.checkout_select_address_error);
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
          shopItems.first.product.shop?.name ??
              '${localization.checkout_shop_fallback_prefix}${entry.key}',
        );
      }
    }

    if (!mounted) return;
    setState(() => _submitting = false);

    if (failedShops.isEmpty) {
      context.read<CartBloc>().add(const ClearCartEvent());
      showGlobalMessage(localization.checkout_order_success, isError: false);
      Navigator.of(context).pushReplacementNamed('/orders');
    } else {
      showGlobalMessage(
        '${localization.checkout_order_failed_prefix}${failedShops.join(', ')}',
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
                  _buildPersonalInfoSection(),
                  const SizedBox(height: 16),
                  _buildAddressSection(),
                  const SizedBox(height: 16),
                  ..._groupByShop(items).entries.map(
                        (entry) => _buildShopGroup(entry.key, entry.value, currency),
                      ),
                  _buildPaymentSection(),
                  const SizedBox(height: 16),
                  _buildNoteField(),
                ],
              ),
            ),
      bottomNavigationBar: items.isEmpty
          ? null
          : _buildBottomBar(items, total, currency),
    );
  }

  Widget _buildPersonalInfoSection() {
    final l10n = S.of(context);
    return _sectionCard(
      title: l10n.sahsy_maglumatlar,
      child: Column(
        children: [
          _plainField(controller: _nameController, hint: l10n.ady),
          const SizedBox(height: 10),
          _plainField(controller: _surnameController, hint: l10n.familiyasy),
          const SizedBox(height: 10),
          _plainField(
            controller: _phoneController,
            hint: l10n.telefon_hint,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          _plainField(
            controller: _emailController,
            hint: l10n.email_hint,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    final l10n = S.of(context);

    return _sectionCard(
      title: l10n.eltip_berme_adresi_bashlyk,
      child: Column(
        children: [
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              final addresses =
                  state is AddressLoaded ? state.addresses : const <AddressModel>[];
              return TextField(
                controller: _manualAddressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: l10n.address_field_hint,
                  filled: true,
                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.bookmark_outline, color: AppColors.primaryGreen),
                    onPressed: addresses.isEmpty
                        ? () => AddressFormSheet.show(context)
                        : () => _pickAddress(addresses),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _plainField(controller: _cityController, hint: l10n.saher_hint),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.welayat_hint,
              style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _openRegionPicker,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primaryGreen),
              ),
              child: Text(
                _selectedRegionLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _plainField(
            controller: _postalCodeController,
            hint: l10n.pocta_indeksi_hint,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  Widget _buildShopGroup(int shopId, List<CartModel> shopItems, String currency) {
    final l10n = S.of(context);
    final shopName = shopItems.first.product.shop?.name ??
        '${l10n.checkout_shop_fallback_prefix}$shopId';
    final method = _shopDeliveryMethods[shopId] ?? 'courier';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.storefront_outlined, size: 18, color: AppColors.primaryGreen),
              const SizedBox(width: 6),
              Text(
                shopName,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
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
                  Text('x${item.quantity}',
                      style: const TextStyle(color: AppColors.lightTextSecondary)),
                  const SizedBox(width: 8),
                  Text(
                    '${(item.product.price * item.quantity).toStringAsFixed(2)} ${item.product.currency}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.eltip_berme_usuly,
            style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
          ),
          const SizedBox(height: 8),
          _deliveryOption(
            shopId: shopId,
            value: 'courier',
            selected: method == 'courier',
            icon: Icons.delivery_dining_outlined,
            title: l10n.kurher_wabrum,
            subtitle: '13:00 - 20:00',
            price: '25 $currency',
          ),
          const SizedBox(height: 10),
          _deliveryOption(
            shopId: shopId,
            value: 'pickup',
            selected: method == 'pickup',
            icon: Icons.storefront_outlined,
            title: l10n.ozi_alyp_gitmek,
            subtitle: '10:00 - 20:00',
            price: '0 $currency',
          ),
        ],
      ),
    );
  }

  Widget _deliveryOption({
    required int shopId,
    required String value,
    required bool selected,
    required IconData icon,
    required String title,
    required String subtitle,
    required String price,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _shopDeliveryMethods[shopId] = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 22, color: AppColors.lightTextSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary)),
                ],
              ),
            ),
            Text(
              price,
              style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection() {
    final l10n = S.of(context);
    final options = <(String, String)>[
      ('card_in_shop', l10n.bank_kartockasy_dukanda),
      ('cash', l10n.nagt_tolegi),
      ('stripe', 'Visa, MasterCard (Stripe)'),
      ('qr', l10n.toleg_qr),
    ];

    return _sectionCard(
      title: l10n.toleg_usuly,
      child: Column(
        children: options.map((opt) {
          final (value, label) = opt;
          final selected = _paymentMethod == value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => setState(() => _paymentMethod = value),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      selected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 12),
                    Text(label,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNoteField() {
    return _sectionCard(
      title: S.of(context).bellik,
      child: TextField(
        controller: _noteController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: S.of(context).checkout_note_hint,
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _plainField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
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
                    Text(S.of(context).jemi, style: const TextStyle(color: AppColors.lightTextSecondary)),
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