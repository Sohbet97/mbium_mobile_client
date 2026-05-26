import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class TopProductsTabsWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController tabController;

  const TopProductsTabsWidget({super.key, required this.tabController});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.deepForest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TabBar(
          controller: tabController,
          indicator: BoxDecoration(
            color: AppColors.secondaryGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: AppColors.navWhite,
          unselectedLabelColor: AppColors.navWhite.withValues(alpha: 0.6),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          tabs: [
            Tab(text: l10n.ahlisi),
            Tab(text: l10n.satuw_liderleri),
            Tab(text: l10n.in_meshgurlar),
          ],
        ),
      ),
    );
  }
}