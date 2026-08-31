import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:mbium_mobile_client/feature/person/bloc/person_bloc.dart';

import '../../../generated/l10n.dart';

enum _DeliveryMethod { delivery, pickup }

class SargytEtScreen extends StatefulWidget {
  const SargytEtScreen({super.key});

  @override
  State<SargytEtScreen> createState() => _SargytEtScreenState();
}

class _SargytEtScreenState extends State<SargytEtScreen> {
  final _noteController = TextEditingController();
  final _manualAddressController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _postalIndexController = TextEditingController();
  AddressModel? _selectedAddress;
  bool _useManualAddress = false;
  bool _submitting = false;
  _DeliveryMethod _deliveryMethod = _DeliveryMethod.delivery;

  // UI-only, not wired to the order payload yet.
  int _paymentMethodIndex = 0;
  final Map<int, bool> _shopCourierSelected = {};

  @override
  void initState() {
    super.initState();
    context.read<AddressBloc>().add(LoadAddressesEvent());

    final person = context.read<PersonBloc>().state.personModel;
    if (person != null) {
      _firstNameController.text = person.name ?? '';
      _lastNameController.text = person.surname ?? '';
      _emailController.text = person.email;
      _phoneController.text = person.phone ?? '';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _manualAddressController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _postalIndexController.dispose();
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
                title: Text(
                  a.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
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
    final localization = S.of(context);
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      showGlobalMessage(localization.checkout_enter_fullname_error);
      return;
    }
    if (phone.isEmpty) {
      showGlobalMessage(localization.checkout_enter_phone_error);
      return;
    }
    if (email.isEmpty) {
      showGlobalMessage(localization.checkout_enter_email_error);
      return;
    }

    final isPickup = _deliveryMethod == _DeliveryMethod.pickup;
    final deliveryAddress = isPickup
        ? ''
        : _useManualAddress
        ? _manualAddressController.text.trim()
        : _selectedAddress?.address ?? '';
    if (!isPickup && deliveryAddress.isEmpty) {
      showGlobalMessage(
        _useManualAddress
            ? localization.checkout_enter_address_error
            : localization.checkout_select_address_error,
      );
      return;
    }
    if (items.isEmpty || _submitting) return;

    setState(() => _submitting = true);
    final orderRepository = context.read<OrderRepository>();
    final groups = _groupByShop(items);
    final failedShops = <String>[];
    final postalIndex = _postalIndexController.text.trim();

    for (final entry in groups.entries) {
      final shopItems = entry.value;
      final payload = {
        'shop_id': entry.key,
        'delivery_address': deliveryAddress,
        'delivery_type': isPickup ? 'pickup' : 'delivery',
        'full_name': fullName,
        'phone': phone,
        'email': email,
        if (postalIndex.isNotEmpty) 'postal_index': postalIndex,
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
    final items = cartState is CartLoaded
        ? cartState.items
        : const <CartModel>[];
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
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                children: [
                  _sectionCard(
                    title: localization.checkout_personal_info_title,
                    child: _buildPersonSection(),
                  ),
                  if (_deliveryMethod == _DeliveryMethod.delivery)
                    _sectionCard(
                      title: localization.checkout_delivery_address_title,
                      child: _buildAddressSection(),
                    ),
                  _sectionCard(
                    title: localization.toleg_usuly,
                    child: _buildPaymentMethodSection(),
                  ),
                  _sectionCard(
                    title: localization.checkout_note_title,
                    child: _buildNoteField(),
                  ),
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

  Widget _buildPersonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _firstNameController,
          decoration: InputDecoration(
            hintText: S.of(context).checkout_first_name_hint,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryGreen,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _lastNameController,
          decoration: InputDecoration(
            hintText: S.of(context).checkout_last_name_hint,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.primaryGreen,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: S.of(context).telefon_belgisi,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              color: AppColors.primaryGreen,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: S.of(context).e_pocta,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.primaryGreen,
            ),
            filled: true,
            fillColor: Colors.grey.shade200,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPostalIndexField() {
    return TextField(
      controller: _postalIndexController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: S.of(context).pocta_indeksi_hint,
        prefixIcon: const Icon(
          Icons.local_post_office_outlined,
          color: AppColors.primaryGreen,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
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
              checkmarkColor: Colors.white,
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
              label: Text(S.of(context).checkout_manual_address),
              selected: _useManualAddress,
              checkmarkColor: Colors.white,
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
        _useManualAddress
            ? _buildManualAddressField()
            : _buildSavedAddressTile(),
        const SizedBox(height: 10),
        _buildPostalIndexField(),
      ],
    );
  }

  Widget _buildManualAddressField() {
    return TextField(
      controller: _manualAddressController,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: S.of(context).address_field_hint,
        prefixIcon: const Icon(
          Icons.location_on_outlined,
          color: AppColors.primaryGreen,
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
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

        final addresses = state is AddressLoaded
            ? state.addresses
            : const <AddressModel>[];
        return GestureDetector(
          onTap: addresses.isEmpty
              ? () => AddressFormSheet.show(context)
              : () => _pickAddress(addresses),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primaryGreen.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _selectedAddress != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedAddress!.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedAddress!.address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          S.of(context).address_add,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.lightTextSecondary,
                ),
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
        hintText: S.of(context).checkout_note_hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Wraps a titled block in the app's white rounded-card look used across the screen.
  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // A single tappable radio-style row (grey pill with a leading radio icon).
  Widget _buildRadioRow({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    IconData? leadingIcon,
    String? trailing,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(width: 10),
            if (leadingIcon != null) ...[
              Icon(leadingIcon, color: AppColors.lightTextSecondary, size: 20),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // UI-only payment method picker — not sent to the order payload yet.
  Widget _buildPaymentMethodSection() {
    final options = [
      S.of(context).checkout_payment_card_hint,
      S.of(context).checkout_payment_cash_hint,
      S.of(context).checkout_payment_stripe_hint,
      S.of(context).checkout_payment_qr_hint,
    ];
    return Column(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i != 0) const SizedBox(height: 10),
          _buildRadioRow(
            label: options[i],
            selected: _paymentMethodIndex == i,
            onTap: () => setState(() => _paymentMethodIndex = i),
          ),
        ],
      ],
    );
  }

  Widget _buildShopGroup(int shopId, List<CartModel> shopItems) {
    final shopName =
        shopItems.first.product.shop?.name ??
        '${S.of(context).checkout_shop_fallback_prefix}$shopId';
    final isCourierSelected = _shopCourierSelected[shopId] ?? true;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.storefront_outlined,
                size: 18,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(width: 6),
              Text(
                shopName,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // The only delivery-type control on the screen — drives _deliveryMethod
          // (which shows/hides the address card) but the choice itself isn't
          // sent to the order payload yet.
          _buildRadioRow(
            label: S.of(context).checkout_delivery_courier_label,
            leadingIcon: Icons.local_shipping_outlined,
            selected: isCourierSelected,
            onTap: () => setState(() {
              _shopCourierSelected[shopId] = true;
              _deliveryMethod = _DeliveryMethod.delivery;
            }),
          ),
          const SizedBox(height: 10),
          _buildRadioRow(
            label: S.of(context).checkout_delivery_pickup_label,
            leadingIcon: Icons.storefront_outlined,
            selected: !isCourierSelected,
            onTap: () => setState(() {
              _shopCourierSelected[shopId] = false;
              _deliveryMethod = _DeliveryMethod.pickup;
            }),
          ),
          const Divider(height: 24),
          ...shopItems.map((item) => _buildOrderItemRow(item)),
        ],
      ),
    );
  }

  Widget _buildOrderItemRow(CartModel item) {
    final imageUrl = item.product.primaryThumbnailUrl;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => _itemImagePlaceholder(),
                  )
                : _itemImagePlaceholder(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.variantLabel != null
                      ? '${item.product.name} (${item.variantLabel})'
                      : item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  'x${item.quantity}',
                  style: TextStyle(color: AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(item.product.price * item.quantity).toStringAsFixed(2)} ${item.product.currency}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _itemImagePlaceholder() {
    return Container(
      width: 44,
      height: 44,
      color: AppColors.navBarGrey,
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: AppColors.textLightGrey,
        size: 18,
      ),
    );
  }

  Widget _buildBottomBar(List<CartModel> items, double total, String currency) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
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
                    Text(
                      S.of(context).jemi,
                      style: TextStyle(color: AppColors.lightTextSecondary),
                    ),
                    Text(
                      '${total.toStringAsFixed(2)} $currency',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          S.of(context).sargyt_etmek,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
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
