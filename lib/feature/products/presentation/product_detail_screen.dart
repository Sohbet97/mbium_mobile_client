import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/bloc/recently/recently_viewed_bloc.dart';
import 'package:mbium_mobile_client/feature/products/extensions/product_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_images_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_info_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_description_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_shop_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_tags_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  AppLanguage _getLanguage(String code) {
    switch (code) {
      case 'ru':
        return AppLanguage.ru;
      case 'en':
        return AppLanguage.en;
      default:
        return AppLanguage.tk;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<RecentlyViewedBloc>().add(AddRecentlyViewed(widget.product));
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final languageCode = context.read<MainBloc>().state.languageCode;
    final lang = _getLanguage(languageCode);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.nameByLang(lang),
          style: textStyles.s13w600clBlack,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductDetailImagesWidget(product: widget.product),
            const SizedBox(height: 8),

            ProductDetailInfoWidget(product: widget.product),
            const SizedBox(height: 8),

            ProductDetailShopWidget(
              product: widget.product,
              onTap: () {
              
              },
            ),
            const SizedBox(height: 8),

            ProductDetailDescriptionWidget(product: widget.product),
            const SizedBox(height: 8),

            ProductDetailTagsWidget(product: widget.product),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.navWhite,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Sebede goş',
            style: textStyles.s16w600clBlack.copyWith(
              color: AppColors.navWhite,
            ),
          ),
        ),
      ),
    );
  }
}