import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'widget/notification_banner_widget.dart';

class OtherNotificationsScreen extends StatelessWidget {
  const OtherNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.basha_bildirisher, style: textStyles.s16w600clBlack),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.lightTextSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const NotificationBannerWidget(),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: AppColors.lightTextSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.harytlar_yok,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}