import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Добавлено для HapticFeedback
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cart_page/bloc/cart_bloc.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class CartControlWidget extends StatelessWidget {
  const CartControlWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final qty = context.select<CartBloc, int>((bloc) {
      final s = bloc.state;
      return s is CartLoaded ? s.quantityOf(product.id) : 0;
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
      child: qty == 0
          ? _PremiumAddButton(
              key: const ValueKey('add_btn'),
              onTap: () {
                HapticFeedback.lightImpact(); // Дорогой тактильный отклик
                context.read<CartBloc>().add(AddToCartEvent(product));
              },
            )
          : _PremiumStepper(
              key: const ValueKey('stepper'),
              quantity: qty,
              onDecrement: () {
                HapticFeedback.lightImpact();
                context.read<CartBloc>().add(
                  UpdateQuantityEvent(product.id, qty - 1),
                );
              },
              onIncrement: () {
                HapticFeedback.lightImpact();
                context.read<CartBloc>().add(
                  UpdateQuantityEvent(product.id, qty + 1),
                );
              },
            ),
    );
  }
}

class _PremiumAddButton extends StatelessWidget {
  const _PremiumAddButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
