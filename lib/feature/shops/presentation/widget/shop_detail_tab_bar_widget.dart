import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ShopDetailTabBarWidget extends StatelessWidget {
  final TabController controller;

  const ShopDetailTabBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: controller,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.lightTextSecondary,
        indicatorColor: AppColors.primaryGreen,
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        tabs: [
          Tab(text: l10n.dukan_barada),
          Tab(text: l10n.harytlar),
          Tab(text: l10n.sorag_jogap),
        ],
      ),
    );
  }
}