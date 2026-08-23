import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/feature/products/extensions/product_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/filter_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_badges_overlay_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_bottom_bar_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_category_products_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_delivery_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_description_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_gallery_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_images_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_price_card_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_specs_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_top_bar_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../generated/l10n.dart';
import '../../cart_page/presentation/widget/cart_alibaba_widget.dart';

class ProductDetailDataScreen extends StatelessWidget {
  const ProductDetailDataScreen({
    super.key,
    required this.model,
    required this.litleProductModel,
  });

  final ProductDetailModel model;
  final ProductModel litleProductModel;

  // int? get _discountPercent {
  //   if (model.compareAtPrice != null && model.compareAtPrice! > model.price) {
  //     return (((model.compareAtPrice! - model.price) / model.compareAtPrice!) *
  //             100)
  //         .round();
  //   }
  //   return null;
  // }

  void _share(AppLanguage lang) {
    final name = model.nameByLang(lang);
    final price = '${model.price.toStringAsFixed(2)} ${model.currency}';
    final url = 'https://mbium.com/products/${model.id}';

    final text = '$name\n$price\n$url';

    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final lang = AppLanguage.fromCode(
      context.read<MainBloc>().state.languageCode,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ProductDetailTopBarWidget(
        product: litleProductModel,
        onShare: () => _share(lang),
      ),
      bottomNavigationBar: ProductDetailBottomBarWidget(
        model: model,
        product: litleProductModel,
        localization: localization,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductDetailImagesWidget(
              product: model,
              littleProducts: litleProductModel,
            ),
            if (model.deliveryTypes.isNotEmpty) ...[
              const SizedBox(height: 8),
              ProductDetailDeliveryWidget(
                deliveryTypes: model.deliveryTypes,
                lang: lang,
              ),
            ],
            const SizedBox(height: 8),
            ProductDetailPriceCardWidget(product: model),
            const SizedBox(height: 8),

            ProductDetailDescriptionWidget(
              description: model.descriptionByLang(lang),
              name: model.nameByLang(lang),
              totalReview: model.reviewCount,
              productId: model.id,
            ),
            if (model.description.isNotEmpty) const SizedBox(height: 8),
            ProductDetailSpecsWidget(product: model),
            const SizedBox(height: 8),

            const CartAlibabaWidget(),
            const SizedBox(height: 8),

            ProductDetailGalleryWidget(media: model.galleryMedia),
            const SizedBox(height: 16),

            ProductDetailCategoryProductsWidget(
              categoryId: model.categoryId,
              excludeProductId: model.id,
              categoryName: model.category?.name,
              title: localization.menzes_harytlar,
              filterModel: FilterModel(
                categoryId: model.categoryId,
                limit: 30,
                page: 1,
                sort: 'price_asc',
              ),
            ),
            const SizedBox(height: 8),

            ProductDetailCategoryProductsWidget(
              categoryId: model.shopId,
              excludeProductId: model.id,
              categoryName: model.shop?.name,
              title: localization.shop_harytlar,
              filterModel: FilterModel(
                categoryId: null,
                shopId: model.shopId,
                limit: 30,
                page: 1,
                sort: 'price_asc',
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
