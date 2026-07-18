import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/brands/models/brand_model.dart';

/// Header shown at the top of [BrandDetailScreen]: logo, name and
/// description of the brand.
class BrandDetailHeader extends StatelessWidget {
  const BrandDetailHeader({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BrandLogo(logoUrl: brand.logoUrl),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  brand.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (brand.description != null &&
                    brand.description!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    brand.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({required this.logoUrl});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: logoUrl == null || logoUrl!.isEmpty
          ? Icon(Icons.storefront_outlined, color: Colors.grey.shade400, size: 30)
          : ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                logoUrl!,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Icon(
                  Icons.storefront_outlined,
                  color: Colors.grey.shade400,
                  size: 30,
                ),
              ),
            ),
    );
  }
}

/// Section title above the brand's product grid.
class BrandDetailSectionTitle extends StatelessWidget {
  const BrandDetailSectionTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    );
  }
}
