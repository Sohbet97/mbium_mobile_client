import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';

import '../../../../generated/l10n.dart';

/// Opens a bottom sheet to pick a variant (e.g. color) and, if that variant
/// has sizes, a size, then adds the chosen combo to the cart. Call this
/// instead of dispatching AddToCartEvent directly whenever
/// `model.variants.isNotEmpty`.
Future<void> showVariantPickerSheet(
  BuildContext context, {
  required ProductDetailModel model,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<CartBloc>(),
      child: _VariantPickerSheet(model: model),
    ),
  );
}

class _VariantPickerSheet extends StatefulWidget {
  const _VariantPickerSheet({required this.model});
  final ProductDetailModel model;

  @override
  State<_VariantPickerSheet> createState() => _VariantPickerSheetState();
}

class _VariantPickerSheetState extends State<_VariantPickerSheet> {
  late ProductVariant _variant;
  ProductVariantSize? _size;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _variant = widget.model.variants.first;
    _size = _variant.availableSizes.isNotEmpty
        ? _variant.availableSizes.first
        : null;
  }

  void _selectVariant(ProductVariant variant) {
    setState(() {
      _variant = variant;
      _size = variant.availableSizes.isNotEmpty
          ? variant.availableSizes.first
          : null;
      _quantity = 1;
    });
  }

  void _selectSize(ProductVariantSize size) {
    HapticFeedback.selectionClick();
    setState(() => _size = size);
  }

  bool get _needsSize => _variant.sizes.isNotEmpty;
  bool get _canConfirm => !_needsSize || _size != null;

  double get _unitPrice => _size?.price ?? _variant.price ?? widget.model.price;

  void _confirm() {
    final product = widget.model.toProductModel(variant: _variant, size: _size);
    final label = [
      _variant.name,
      _size?.size?.name,
    ].whereType<String>().where((s) => s.isNotEmpty).join(' / ');

    context.read<CartBloc>().add(
      AddToCartEvent(
        product,
        variantId: _variant.id,
        variantSizeId: _size?.id,
        variantLabel: label.isEmpty ? null : label,
        quantity: _quantity,
      ),
    );
    Navigator.of(context).pop();
  }

  void _remove() {
    context.read<CartBloc>().add(
      RemoveFromCartEvent(
        widget.model.id,
        variantId: _variant.id,
        variantSizeId: _size?.id,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final variants = widget.model.variants;

    // Quantity already in the cart for the currently selected variant+size —
    // drives the "remove from cart" affordance below.
    final currentQty = context.select<CartBloc, int>((bloc) {
      final s = bloc.state;
      return s is CartLoaded
          ? s.quantityOf(
              widget.model.id,
              variantId: _variant.id,
              variantSizeId: _size?.id,
            )
          : 0;
    });

    final localization = S.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textLightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.model.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${_unitPrice.toStringAsFixed(2)} ${widget.model.currency}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                localization.variants,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: variants.map((v) {
                  final selected = v.id == _variant.id;
                  return ChoiceChip(
                    label: Text(v.name),
                    selected: selected,
                    onSelected: (_) => _selectVariant(v),
                    selectedColor: AppColors.primaryGreen,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : null,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),

              if (_needsSize) ...[
                const SizedBox(height: 16),
                Text(
                  localization.sizes,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _variant.sizes.map((s) {
                    final selected = _size?.id == s.id;
                    final outOfStock = s.stock <= 0 || !s.isActive;
                    return ChoiceChip(
                      label: Text(
                        s.size?.name ?? '${localization.sizes} ${s.sizeId}',
                      ),
                      selected: selected,
                      onSelected: outOfStock ? null : (_) => _selectSize(s),
                      selectedColor: AppColors.primaryGreen,
                      disabledColor: AppColors.navBarGrey,
                      labelStyle: TextStyle(
                        color: outOfStock
                            ? AppColors.textLightGrey
                            : selected
                            ? Colors.white
                            : null,
                        decoration: outOfStock
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
                if (_size != null && _size!.stock <= 5) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${localization.stoc}: ${_size!.stock}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                ],
              ],

              if (currentQty > 0) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      '${localization.korzinada}: $currentQty',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _remove,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(
                        localization.delete_from_cart,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$_quantity',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () => setState(() => _quantity++),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 180,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _canConfirm ? _confirm : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23),
                        ),
                      ),
                      child: Text(
                        localization.add_to_cart,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryGreen : AppColors.navBarGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : AppColors.textLightGrey,
          size: 16,
        ),
      ),
    );
  }
}
