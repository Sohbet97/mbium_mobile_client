import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/home_menu_widget.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/search_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/promo_banner_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/delivery_coin_banner_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/category_tabs_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/section_header_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/product_section_widget.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/horizontal_product_list_widget.dart';

import '../../../../generated/l10n.dart';

final _mockProducts = List.generate(
  10,
  (i) => ProductModel(
    imageUrl: 'https://picsum.photos/seed/${i + 1}/200/220',
    price: '${(i + 1) * 10} TMT',
    name: 'NIKE sport hudisi',
  ),
);

class HomeProductsPage extends StatefulWidget {
  const HomeProductsPage({super.key});

  @override
  State<HomeProductsPage> createState() => _HomeProductsPageState();
}

class _HomeProductsPageState extends State<HomeProductsPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final List<String> categories = [
      l10n.ahlisi,
      l10n.ayakgaplar,
      l10n.egin_esikler,
      l10n.elektronika,
      l10n.oyuncaklar,
      l10n.kitaplar,
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SearchWidget(
              controller: _searchController,
              onTapPhoto: () {},
              onTapAudio: () {},
              onTapAi: () {},
              onSubmit: () {},
            ),
          ),
          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: HomeMenuWidget(),
          ),
          const SizedBox(height: 16),

          ProductSectionWidget(
            banner: const PromoBannerWidget(),
            products: _mockProducts,
          ),
          const SizedBox(height: 20),

          CategoryTabsWidget(
            categories: categories,
            onCategorySelected: (index) {},
          ),
          const SizedBox(height: 16),

          SectionHeaderWidget(
            title: l10n.maslahat_beriyanler,
            subtitle: l10n.maslahat_beriyanler_subtitle,
            onSeeAll: () {},
          ),
          const SizedBox(height: 10),
          ProductSectionWidget(products: _mockProducts),
          const SizedBox(height: 20),

          ProductSectionWidget(
            banner: const DeliveryCoinBannerWidget(),
            products: _mockProducts,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
