import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';

/// Expandable "Düşündiriş" (description) card.
class ProductDetailDescriptionWidget extends StatefulWidget {
  const ProductDetailDescriptionWidget({super.key, required this.description});

  final String description;

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
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description_outlined,
                  size: 15,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Düşündiriş',
                style: context.appTextStyles.s13w600clBlack.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState:
                _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
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
        ],
      ),
    );
  }
}
