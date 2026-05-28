import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_banner_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_category_tabs_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_filter_chips_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_horizontal_list_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_menu_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_ondabaryjy_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_search_widget.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shops_section_header_widget.dart';
import '../../../../generated/l10n.dart';

class ShopsPage extends StatefulWidget {
  const ShopsPage({super.key});

  @override
  State<ShopsPage> createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShopsSearchWidget(
            controller: _searchController,
            onTapPhoto: () {},
            onTapAudio: () {},
            onTapAi: () {},
            onSubmit: () {},
          ),
          const SizedBox(height: 10),
          ShopsCategoryTabsWidget(
            onCategorySelected: (index) {},
          ),
          const SizedBox(height: 10),
          const ShopsMenuWidget(),
          const SizedBox(height: 16),
          ShopsSectionHeaderWidget(
            title: l10n.obrazesleri_al,
            onSeeAll: () {},
          ),
          const SizedBox(height: 10),
          const ShopsHorizontalListWidget(),
          const SizedBox(height: 16),
          ShopsSectionHeaderWidget(
            title: l10n.ondabaryjy_ondurijiler,
            onSeeAll: null,
          ),
          const SizedBox(height: 10),
          const ShopsOndabaryjyWidget(),
          const SizedBox(height: 16),
          const ShopsFilterChipsWidget(),
          const SizedBox(height: 16),
          ShopsBannerWidget(
            shopName: l10n.balkan_lale_shop_name,
            description: l10n.balkan_lale_shop_desc,
            onTap: () {},
          ),
          const SizedBox(height: 16),
          const ShopsHorizontalListWidget(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}