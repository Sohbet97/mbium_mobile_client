import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/presentation/pages/ai_agent_page.dart';
import 'package:mbium_mobile_client/feature/home/presentation/pages/city_page.dart';
import 'package:mbium_mobile_client/feature/home/presentation/pages/home_products_page.dart';
import 'package:mbium_mobile_client/feature/home/presentation/pages/shops_page.dart';

import '../../../../generated/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final tabs = <TabItemClass>[
      TabItemClass(
        tab: Tab(text: localization.Ai_agent),
        body: const AiAgetntPage(),
      ),

      TabItemClass(
        tab: Tab(text: localization.products),
        body: const HomeProductsPage(),
      ),
      TabItemClass(
        tab: Tab(text: localization.ondurijiler),
        body: const ShopsPage(),
      ),
      TabItemClass(
        tab: Tab(text: localization.welayatlar_boyunca),
        body: const CityPage(),
      ),
    ];
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        initialIndex: 1,
        child: Column(
          children: [
            TabBar(
              tabs: tabs.map((item) => item.tab).toList(),
              isScrollable: true,
              tabAlignment: TabAlignment.start,
            ),
            Expanded(
              child: TabBarView(
                children: tabs.map((item) => item.body).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabItemClass {
  final Tab tab;
  final Widget body;

  TabItemClass({required this.tab, required this.body});
}
