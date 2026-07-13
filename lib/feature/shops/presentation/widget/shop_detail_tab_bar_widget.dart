import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class ShopDetailTabBarWidget extends StatelessWidget {
  final TabController controller;

  const ShopDetailTabBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: controller,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.lightTextSecondary,
        indicatorColor: AppColors.primaryGreen,
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
        tabs: const [
          Tab(text: 'Dükan barada'),
          Tab(text: 'Harytlar'),
          Tab(text: 'Teswirler'),
        ],
      ),
    );
  }
}