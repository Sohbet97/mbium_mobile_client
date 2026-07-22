import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Добавлено для HapticFeedback
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/network/interceptors.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/variant_picker_sheet.dart';

class CartControlWidget extends StatefulWidget {
  const CartControlWidget({super.key, required this.product});

  final ProductModel product;

  @override
  State<CartControlWidget> createState() => _CartControlWidgetState();
}

class _CartControlWidgetState extends State<CartControlWidget> {
  // Grid cards only carry ProductModel (no variants), so whether this
  // product has variants is unknown until we fetch its detail — cached here
  // so repeated taps on the same card don't re-fetch.
  ProductDetailModel? _cachedDetail;
  bool _loading = false;

  @override
  void didUpdateWidget(covariant CartControlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      _cachedDetail = null;
      _loading = false;
    }
  }

  Future<void> _handleAddTap() async {
    if (_loading) return;
    HapticFeedback.lightImpact();

    final cached = _cachedDetail;
    if (cached != null) {
      if (cached.variants.isNotEmpty) {
        showVariantPickerSheet(context, model: cached);
      } else {
        context.read<CartBloc>().add(AddToCartEvent(widget.product));
      }
      return;
    }

    setState(() => _loading = true);
    try {
      final detail = await context.read<ProductRepository>().getProductDetail(
        widget.product.id,
      );
      if (!mounted) return;
      _cachedDetail = detail;
      if (detail.variants.isNotEmpty) {
        await showVariantPickerSheet(context, model: detail);
      } else {
        context.read<CartBloc>().add(AddToCartEvent(widget.product));
      }
    } catch (_) {
      showGlobalMessage('Не удалось загрузить товар');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final plainQty = context.select<CartBloc, int>((bloc) {
      final s = bloc.state;
      return s is CartLoaded ? s.quantityOf(widget.product.id) : 0;
    });
    final totalQty = context.select<CartBloc, int>((bloc) {
      final s = bloc.state;
      return s is CartLoaded
          ? s.totalQuantityOfProduct(widget.product.id)
          : 0;
    });

    // Премиальный подход: используем AnimatedSwitcher для плавного перехода между состояниями
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: _loading
          ? const _PremiumLoadingButton(key: ValueKey('loading_btn'))
          : plainQty > 0
          // Only a plain (no-variant) line exists — safe to mutate directly,
          // no need to know whether the product has variants.
          ? _PremiumStepper(
              key: const ValueKey('stepper'),
              quantity: plainQty,
              onDecrement: () {
                HapticFeedback.lightImpact();
                context.read<CartBloc>().add(
                  UpdateQuantityEvent(widget.product.id, plainQty - 1),
                );
              },
              onIncrement: () {
                HapticFeedback.lightImpact();
                context.read<CartBloc>().add(
                  UpdateQuantityEvent(widget.product.id, plainQty + 1),
                );
              },
            )
          // Quantity exists only via variant line(s) added elsewhere (e.g.
          // the product page) — show a badge so the card reflects it's in
          // the cart; tapping re-opens the picker rather than guessing which
          // variant line to mutate.
          : _PremiumAddButton(
              key: const ValueKey('add_btn'),
              badgeCount: totalQty,
              onTap: _handleAddTap,
            ),
    );
  }
}

class _PremiumLoadingButton extends StatelessWidget {
  const _PremiumLoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(9),
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: Colors.white,
      ),
    );
  }
}

class _PremiumAddButton extends StatelessWidget {
  const _PremiumAddButton({
    super.key,
    required this.onTap,
    this.badgeCount = 0,
  });

  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width:
              36, // Чуть увеличили для лучшего UX (минимальный размер тач-зоны Apple/Google ~44, но в сетке 36 выглядит аккуратнее)
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withOpacity(0.25),
                blurRadius: 8,
                offset: const Offset(
                  0,
                  3,
                ), // Мягкая тень под кнопкой добавляет глубины
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              splashColor: Colors.white24,
              highlightColor: Colors.white12,
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              constraints: const BoxConstraints(minWidth: 18),
              decoration: BoxDecoration(
                color: AppColors.errorRed,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                '$badgeCount',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _PremiumStepper extends StatelessWidget {
  const _PremiumStepper({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PremiumStepBtn(
            icon: Icons.remove,
            onTap: onDecrement,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
          ),

          // Анимированное изменение самой цифры внутри степпера
          Container(
            constraints: const BoxConstraints(minWidth: 24),
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Text(
                '$quantity',
                key: ValueKey<int>(quantity), // Важно для AnimatedSwitcher
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [
                    FontFeature.tabularFigures(),
                  ], // Моноширинные цифры, чтобы кнопка не дергалась при изменении ширины текста
                ),
              ),
            ),
          ),

          _PremiumStepBtn(
            icon: Icons.add,
            onTap: onIncrement,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumStepBtn extends StatelessWidget {
  const _PremiumStepBtn({
    required this.icon,
    required this.onTap,
    required this.borderRadius,
  });

  final IconData icon;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        splashColor: Colors.white24,
        highlightColor: Colors.white12,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}
