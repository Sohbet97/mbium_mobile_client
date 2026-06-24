import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductDetailFeaturesWidget extends StatefulWidget {
  final ProductModel product;

  const ProductDetailFeaturesWidget({super.key, required this.product});

  @override
  State<ProductDetailFeaturesWidget> createState() =>
      _ProductDetailFeaturesWidgetState();
}

class _ProductDetailFeaturesWidgetState
    extends State<ProductDetailFeaturesWidget> {
  bool _expanded = false;

  IconData _getIcon(String text) {
    final t = text.toLowerCase().trim();
    if (t.contains('amoled') || t.contains('oled') || t.contains('ekran') ||
        t.contains('display') || t.contains('screen') || t.contains('lcd'))
      return Icons.tv_outlined;
    if (t.contains('mp') || t.contains('kamera') || t.contains('camera') ||
        t.contains('ultrawide') || t.contains('macro'))
      return Icons.camera_alt_outlined;
    if (t.contains('mah') || t.contains('batarýa') || t.contains('battery') ||
        t.contains('zarýad') || t.contains('charge'))
      return Icons.battery_charging_full_outlined;
    if (t.contains('snapdragon') || t.contains('işlemçi') || t.contains('cpu') ||
        t.contains('processor') || t.contains('chip') || t.contains('mediatek') ||
        t.contains('exynos') || t.contains('intel') || t.contains('amd') ||
        t.contains('ryzen') || t.contains('core i'))
      return Icons.memory_outlined;
    if (t.contains('ram') || t.contains('gb') || t.contains('tb') ||
        t.contains('ssd') || t.contains('hdd') || t.contains('storage'))
      return Icons.storage_outlined;
    if (t.contains('wifi') || t.contains('5g') || t.contains('4g') ||
        t.contains('bluetooth') || t.contains('nfc'))
      return Icons.wifi_outlined;
    if (t.contains('android') || t.contains('windows') || t.contains('ios') ||
        t.contains('macos') || t.contains('os'))
      return Icons.phone_android_outlined;
    if (t.contains('gram') || t.contains('kg') || t.contains('agyr') ||
        t.contains('weight'))
      return Icons.scale_outlined;
    if (t.contains('inch') || t.contains('"') || t.contains('sm') ||
        t.contains('mm'))
      return Icons.straighten_outlined;
    if (t.contains('reňk') || t.contains('color') || t.contains('colour'))
      return Icons.palette_outlined;
    if (t.contains('usb') || t.contains('hdmi') || t.contains('port'))
      return Icons.usb_outlined;
    if (t.contains('ses') || t.contains('audio') || t.contains('speaker'))
      return Icons.volume_up_outlined;
    return Icons.info_outline;
  }

  Color _getColor(String text) {
    final t = text.toLowerCase().trim();
    if (t.contains('amoled') || t.contains('oled') || t.contains('ekran') ||
        t.contains('display') || t.contains('lcd'))
      return AppColors.featurePurple;
    if (t.contains('mp') || t.contains('kamera') || t.contains('camera'))
      return AppColors.featureCyan;
    if (t.contains('mah') || t.contains('batarýa') || t.contains('battery'))
      return AppColors.featureGreen;
    if (t.contains('snapdragon') || t.contains('işlemçi') || t.contains('cpu') ||
        t.contains('intel') || t.contains('amd'))
      return AppColors.featureOrange;
    if (t.contains('ram') || t.contains('gb') || t.contains('ssd'))
      return AppColors.featureBlue;
    if (t.contains('wifi') || t.contains('5g') || t.contains('bluetooth'))
      return AppColors.featureTeal;
    if (t.contains('android') || t.contains('windows') || t.contains('ios'))
      return AppColors.featureGrey;
    return AppColors.primaryGreen;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final product = widget.product;

    final descParts = product.description
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final visibleParts =
        _expanded ? descParts : descParts.take(3).toList();

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
          Text('Esasy aýratynlyklar', style: textStyles.s13w600clBlack),
          const SizedBox(height: 12),

          ...visibleParts.map((part) {
            final icon = _getIcon(part);
            final color = _getColor(part);

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
                    child: Text(
                      part,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.lightTextPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          if (descParts.length > 3)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                children: [
                  Text(
                    _expanded ? 'Az görkez' : 'Has giňişleýin',
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