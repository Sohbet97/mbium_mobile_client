import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/category/models/category_modes.dart';
import '../widget/top_products_header_widget.dart';
import '../widget/top_products_tabs_widget.dart';
import '../widget/ahlisi_tab_widget.dart';
import '../widget/satuw_liderleri_tab_widget.dart';
import '../widget/in_meshgurlar_tab_widget.dart';

class TopProductsPage extends StatefulWidget {
  const TopProductsPage({super.key});

  @override
  State<TopProductsPage> createState() => _TopProductsPageState();
}

class _TopProductsPageState extends State<TopProductsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: TopProductsHeaderWidget(
              selectedCategory: _selectedCategory,
              onCategoryChanged: (category) =>
                  setState(() => _selectedCategory = category),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TopProductsTabsWidget(tabController: _tabController),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            AhlisiTabWidget(categoryId: _selectedCategory?.id),
            const SatuwLiderleriTabWidget(),
            InMeshgurlarTabWidget(categoryId: _selectedCategory?.id),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TopProductsTabsWidget tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return tabBar;
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
