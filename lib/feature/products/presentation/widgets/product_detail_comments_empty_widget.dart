import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailCommentsEmptyWidget extends StatelessWidget {
  const ProductDetailCommentsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          Icon(Icons.chat_bubble_outline_rounded, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text(
            l10n.teswirler_heniz_yok,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}