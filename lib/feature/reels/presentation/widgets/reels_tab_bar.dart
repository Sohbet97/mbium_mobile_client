import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/search/model/search_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReelsTabBar extends StatelessWidget {
  final TabController tabController;
  const ReelsTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TabBar(
            controller: tabController,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            indicatorColor: AppColors.navWhite,
            indicatorWeight: 1,
            indicatorSize: TabBarIndicatorSize.label,
            dividerColor: Colors.transparent,
            tabAlignment: TabAlignment.start,
            padding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.only(right: 16),
            tabs: [
              Tab(text: localization.agza_bolanlarym),
              Tab(text: localization.oz_saherimdaki),
              Tab(text: localization.umumy),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            '/searchScreen',
            arguments: SearchModel(),
          ),
          child: const Icon(Icons.search, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}
