import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailFeaturesWidget extends StatefulWidget {
  final ProductDetailModel product;

  const ProductDetailFeaturesWidget({super.key, required this.product});

  @override
  State<ProductDetailFeaturesWidget> createState() =>
      _ProductDetailFeaturesWidgetState();
}

class _ProductDetailFeaturesWidgetState
    extends State<ProductDetailFeaturesWidget> {
  bool _expanded = false;

  IconData _getIcon(String key) {
    final k = key.toLowerCase().trim();
    if (k.contains('ekran') || k.contains('display') || k.contains('screen')) {
      return Icons.tv_outlined;
    }
    if (k.contains('kamera') || k.contains('camera')) return Icons.camera_alt_outlined;
    if (k.contains('batar') || k.contains('battery')) return Icons.battery_charging_full_outlined;
    if (k.contains('cpu') || k.contains('processor') || k.contains('chip') ||
        k.contains('işlemçi')) {
      return Icons.memory_outlined;
    }
    if (k.contains('ram') || k.contains('storage') || k.contains('hakyza') ||
        k.contains('memory')) {
      return Icons.storage_outlined;
    }
    if (k.contains('wifi') || k.contains('network') || k.contains('bluetooth')) {
      return Icons.wifi_outlined;
    }
    if (k.contains('os') || k.contains('system')) return Icons.phone_android_outlined;
    if (k.contains('weight') || k.contains('agram')) return Icons.scale_outlined;
    if (k.contains('size') || k.contains('ölçeg') || k.contains('dimension')) {
      return Icons.straighten_outlined;
    }
    if (k.contains('color') || k.contains('reňk')) return Icons.palette_outlined;
    if (k.contains('port') || k.contains('usb') || k.contains('hdmi')) {
      return Icons.usb_outlined;
    }
    if (k.contains('audio') || k.contains('ses') || k.contains('speaker')) {
      return Icons.volume_up_outlined;
    }
    return Icons.info_outline;
  }

  Color _getColor(String key) {
    final k = key.toLowerCase().trim();
    if (k.contains('ekran') || k.contains('display')) return AppColors.featurePurple;
    if (k.contains('kamera') || k.contains('camera')) return AppColors.featureCyan;
    if (k.contains('batar') || k.contains('battery')) return AppColors.featureGreen;
    if (k.contains('cpu') || k.contains('processor') || k.contains('işlemçi')) {
      return AppColors.featureOrange;
    }
    if (k.contains('ram') || k.contains('storage') || k.contains('hakyza')) {
      return AppColors.featureBlue;
    }
    if (k.contains('wifi') || k.contains('network')) return AppColors.featureTeal;
    if (k.contains('os') || k.contains('system')) return AppColors.featureGrey;
    return AppColors.primaryGreen;
  }

  Map<String, String> _collectAttributes() {
    final result = <String, String>{};
    for (final variant in widget.product.variants) {
      variant.attributes.forEach((key, value) {
        if (value == null) return;
        final stringValue = value.toString().trim();
        if (stringValue.isEmpty) return;
        result.putIfAbsent(key, () => stringValue);
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final l10n = S.of(context);
    final attributes = _collectAttributes();

    if (attributes.isEmpty) return const SizedBox.shrink();

    final entries = attributes.entries.toList();
    final visible = _expanded ? entries : entries.take(3).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.esasy_aydatynlyklar, style: textStyles.s13w600clBlack),
          const SizedBox(height: 12),
          ...visible.map((entry) {
            final icon = _getIcon(entry.key);
            final color = _getColor(entry.key);

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          if (entries.length > 3)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Text(
                    _expanded ? l10n.az_gorkez : l10n.ginisleyin_oka,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primaryGreen,
                    size: 18,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}