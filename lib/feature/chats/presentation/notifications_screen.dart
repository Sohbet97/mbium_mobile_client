import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'widget/notification_banner_widget.dart';
import 'widget/notification_item_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'category': 'Promoaksiýalar',
      'shopName': 'Wizuwol gözleg',
      'message': 'Salam Müşderi. Siz özüňize gabat gelýän harytlary gözleýärsiňizmi.',
      'imageUrl': null,
      'time': 'Düýn',
      'isNew': true,
    },
    {
      'category': 'Promoaksiýalar',
      'shopName': 'Wizuwol gözleg',
      'message': 'Salam Müşderi. Siz özüňize gabat gelýän harytlary gözleýärsiňizmi.',
      'imageUrl': null,
      'time': 'Düýn',
      'isNew': true,
    },
  ];

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
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.bildirisher, style: textStyles.s16w600clBlack),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined,
                color: AppColors.lightTextSecondary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppColors.lightTextSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NotificationBannerWidget(),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.yany_yakyndakylar,
                style: textStyles.s13w600clBlack,
              ),
            ),
            const SizedBox(height: 12),

            ..._notifications.map(
              (n) => NotificationItemWidget(
                category: n['category'],
                shopName: n['shopName'],
                message: n['message'],
                imageUrl: n['imageUrl'],
                time: n['time'],
                isNew: n['isNew'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}