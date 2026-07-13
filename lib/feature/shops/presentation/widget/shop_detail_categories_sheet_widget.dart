import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ShopDetailCategoriesSheetWidget extends StatelessWidget {
  final ShopDetailModel model;
  final String languageCode;
  final ScrollController scrollController;

  const ShopDetailCategoriesSheetWidget({
    super.key,
    required this.model,
    required this.languageCode,
    required this.scrollController,
  });

  static Future<void> show(
    BuildContext context, {
    required ShopDetailModel model,
    required String languageCode,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.93,
          expand: false,
          builder: (_, scrollController) => ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: ShopDetailCategoriesSheetWidget(
              model: model,
              languageCode: languageCode,
              scrollController: scrollController,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.navBarGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            sliver: SliverToBoxAdapter(
              child: Text(l10n.kategoriyalar, style: textStyles.s16w600clBlack),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverToBoxAdapter(
              child: model.categories.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        l10n.kategoriya_yok,
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    )
                  : Column(
                      children: model.categories.asMap().entries.map((entry) {
                        final isLast = entry.key == model.categories.length - 1;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.category_outlined,
                                    size: 18,
                                    color: AppColors.primaryGreen,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      entry.value.getNameByLanguage(
                                        languageCode,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isLast) const Divider(height: 1),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
