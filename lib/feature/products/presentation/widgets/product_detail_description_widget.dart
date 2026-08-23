import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

import '../../../../generated/l10n.dart';

/// Expandable "Düşündiriş" (description) card.
class ProductDetailDescriptionWidget extends StatefulWidget {
  const ProductDetailDescriptionWidget({
    super.key,
    required this.description,
    required this.name,
    required this.totalReview,
    required this.productId,
  });
  final String name;
  final String description;
  final int totalReview;
  final int productId;

  @override
  State<ProductDetailDescriptionWidget> createState() =>
      _ProductDetailDescriptionWidgetState();
}

class _ProductDetailDescriptionWidgetState
    extends State<ProductDetailDescriptionWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              const SizedBox(width: 8),
              // if (product.tags.isNotEmpty) _TagChip(label: product.tags.first),
            ],
          ),

          const SizedBox(height: 10),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Text(
              widget.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
            secondChild: Text(
              widget.description,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
          if (widget.description.length > 120)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _expanded ? 'Az görkez' : 'Köpräk görkez',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/productReview',
                arguments: widget.productId,
              );
            },
            child: Row(
              children: [
                Text(
                  '${S.of(context).teswirler} (${widget.totalReview})',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
