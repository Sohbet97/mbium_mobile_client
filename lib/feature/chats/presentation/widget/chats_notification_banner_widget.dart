import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ChatsNotificationBannerWidget extends StatefulWidget {
  const ChatsNotificationBannerWidget({super.key});

  @override
  State<ChatsNotificationBannerWidget> createState() =>
      _ChatsNotificationBannerWidgetState();
}

class _ChatsNotificationBannerWidgetState
    extends State<ChatsNotificationBannerWidget> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    final l10n = S.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bonusBannerGreen,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.bonusBannerBorderGreen.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active_outlined,
              color: AppColors.bonusBannerTextGreen, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.mohum_habarlary,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.aiTextBlack,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _visible = false),
            child: const Icon(Icons.close,
                size: 18, color: AppColors.aiTextBlack),
          ),
        ],
      ),
    );
  }
}