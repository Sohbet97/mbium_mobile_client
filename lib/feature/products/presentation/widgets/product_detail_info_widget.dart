import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/extensions/product_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_description_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_price_section_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_quick_links_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_specs_table_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_stats_row_widget.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../../generated/l10n.dart';

class ProductDetailInfoWidget extends StatelessWidget {
  final ProductDetailModel product;

  const ProductDetailInfoWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final l10n = S.of(context);
    final lang = AppLanguage.fromCode(context.read<MainBloc>().state.languageCode);
    final p = product;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductDetailStatsRowWidget(
            rating: p.rating,
            reviewCount: p.reviewCount,
            soldCount: p.soldCount,
            stock: p.stock,
            sellWhenOutOfStock: p.sellWhenOutOfStock,
          ),
          const SizedBox(height: 10),
          Text(
            p.nameByLang(lang),
            style: textStyles.s16w600clBlack.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 6),
          ProductDetailPriceSectionWidget(
            price: p.price,
            currency: p.currency,
            compareAtPrice: p.compareAtPrice,
            tags: p.tags,
          ),
          if (p.category != null || p.shop != null) ...[
            const SizedBox(height: 14),
            ProductDetailQuickLinksWidget(
              categoryName: p.category?.name,
              onCategoryTap: () {
 
              },
              shopName: p.shop?.name,
              onShopTap: () {
                if (p.shop == null) return;
                final shopModel = ShopModel(
                  id: p.shopId,
                  name: p.shop!.name,
                  logo: p.shop!.logo,
                );
                Navigator.pushNamed(context, '/shopDetail', arguments: shopModel);
              },
            ),
          ],
          if (p.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            ProductDetailDescriptionWidget(description: p.descriptionByLang(lang)),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          ProductDetailSpecsTableWidget(
            rows: [
              if (p.sku.isNotEmpty) ProductSpecRow(label: 'SKU', value: p.sku),
              if (p.weight != null)
                ProductSpecRow(label: l10n.agramy, value: '${p.weight} kg'),
              if (p.barcode != null && p.barcode!.isNotEmpty)
                ProductSpecRow(label: l10n.barkode, value: p.barcode!),
            ],
          ),
        ],
      ),
    );
  }
}