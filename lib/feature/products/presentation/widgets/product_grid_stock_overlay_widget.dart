import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductGridStockOverlayWidget extends StatelessWidget {
  const ProductGridStockOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            l10n.stokda_yok,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}