import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailCtaWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailCtaWidget({super.key, required this.model});

  Future<void> _makeCall(BuildContext context) async {
    if (model.phone == null || model.phone!.isEmpty) return;
    final uri = Uri(scheme: 'tel', path: model.phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendMessage(BuildContext context) async {
    if (model.phone == null || model.phone!.isEmpty) return;
    final uri = Uri(scheme: 'sms', path: model.phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.secondaryGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.navWhite.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.navWhite.withValues(alpha: 0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.navWhite.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.headset_mic_outlined,
                        color: AppColors.navWhite,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Has köp maglumat gerekmi?',
                            style: textStyles.s13w600clBlack.copyWith(
                              color: AppColors.navWhite,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Satyjy bilen göni habarlaşyň',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.navWhite.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _sendMessage(context),
                        icon: const Icon(Icons.message_outlined, size: 16),
                        label: const Text('Habarlaş'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navWhite,
                          foregroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _makeCall(context),
                        icon: const Icon(Icons.phone_outlined, size: 16),
                        label: const Text('Jaň et'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.navWhite,
                          side: const BorderSide(
                              color: AppColors.navWhite, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 