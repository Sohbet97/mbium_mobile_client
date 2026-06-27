import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/extensions/product_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../../generated/l10n.dart';

class ProductDetailInfoWidget extends StatefulWidget {
  final ProductDetailModel product;

  const ProductDetailInfoWidget({super.key, required this.product});

  @override
  State<ProductDetailInfoWidget> createState() =>
      _ProductDetailInfoWidgetState();
}

class _ProductDetailInfoWidgetState extends State<ProductDetailInfoWidget> {
  bool _descExpanded = false;

  ProductDetailModel get p => widget.product;

  int? get _discountPercent {
    if (p.compareAtPrice != null && p.compareAtPrice! > p.price) {
      return (((p.compareAtPrice! - p.price) / p.compareAtPrice!) * 100)
          .round();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final lang = AppLanguage.fromCode(
      context.read<MainBloc>().state.languageCode,
    );
    final discount = _discountPercent;
    final localization = S.of(context);

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
          // ── Название + теги ──────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  p.nameByLang(lang),
                  style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(width: 8),
              if (p.tags.isNotEmpty) _TagChip(label: p.tags.first),
            ],
          ),

          // ── Все теги (если > 1) ─────────────────────────────────
          if (p.tags.length > 1) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: p.tags.skip(1).map((t) => _TagChip(label: t)).toList(),
            ),
          ],

          const SizedBox(height: 10),

          // ── Рейтинг / продано / сток ─────────────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _RatingChip(rating: p.rating, reviewCount: p.reviewCount),
              _Divider(),
              _SoldChip(soldCount: p.soldCount),
              _Divider(),
              _StockChip(
                stock: p.stock,
                sellWhenOutOfStock: p.sellWhenOutOfStock,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ── Цена ─────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${p.price.toStringAsFixed(2)} ${p.currency}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
              if (discount != null) ...[
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorRed,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-$discount%',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.navWhite,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${p.compareAtPrice!.toStringAsFixed(2)} ${p.currency}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textLightGrey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          // ── Описание ─────────────────────────────────────────────
          if (p.description.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Text('Düşündiriş', style: textStyles.s13w600clBlack),
            const SizedBox(height: 6),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _descExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Text(
                p.descriptionByLang(lang),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
              secondChild: Text(
                p.descriptionByLang(lang),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextSecondary,
                  height: 1.5,
                ),
              ),
            ),
            if (p.description.length > 120)
              GestureDetector(
                onTap: () => setState(() => _descExpanded = !_descExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _descExpanded ? 'Az görkez' : 'Köpräk görkez',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],

          // ── Детали: SKU / вес / штрихкод ────────────────────────
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          _InfoTable(
            rows: [
              if (p.sku.isNotEmpty) _InfoRow(label: 'SKU', value: p.sku),
              if (p.weight != null)
                _InfoRow(label: localization.agramy, value: '${p.weight} kg'),
              if (p.barcode != null && p.barcode!.isNotEmpty)
                _InfoRow(label: localization.barkode, value: p.barcode!),
              if (p.category != null)
                _InfoRow(
                  label: localization.category,
                  value: p.category!.name,
                  trailing: Icon(Icons.arrow_right, color: Colors.grey),
                  onTap: () {
                    // TODO click to open result screen
                  },
                ),
              if (p.shop != null)
                _InfoRow(
                  label: localization.onduriji,
                  value: p.shop!.name,
                  trailing: Icon(Icons.arrow_right, color: Colors.grey),
                  onTap: () {
                    ShopModel shopModel = ShopModel(
                      id: p.shopId,
                      name: p.shop!.name,
                    );
                    Navigator.pushNamed(
                      context,
                      '/shopDetail',
                      arguments: shopModel,
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Вспомогательные виджеты ──────────────────────────────────────────────────

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bonusBannerGreen,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.bonusBannerTextGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const _RatingChip({required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: AppColors.starYellow, size: 14),
        const SizedBox(width: 3),
        Text(
          '${rating.toStringAsFixed(1)} ($reviewCount)',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _SoldChip extends StatelessWidget {
  final int soldCount;

  const _SoldChip({required this.soldCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.shopping_bag_outlined,
          size: 13,
          color: AppColors.lightTextSecondary,
        ),
        const SizedBox(width: 3),
        Text(
          '$soldCount satyldy',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _StockChip extends StatelessWidget {
  final int stock;
  final bool sellWhenOutOfStock;

  const _StockChip({required this.stock, required this.sellWhenOutOfStock});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (stock == 0 && !sellWhenOutOfStock) {
      color = AppColors.errorRed;
      label = 'Stokda ýok';
    } else if (stock > 0 && stock <= 5) {
      color = Colors.orange;
      label = 'Az galdy: $stock';
    } else {
      color = AppColors.primaryGreen;
      label = 'Stokda bar: $stock';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.inventory_2_outlined, size: 13, color: color),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      '·',
      style: TextStyle(color: AppColors.navBarGrey, fontSize: 16),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;
  const _InfoRow({
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
  });
}

class _InfoTable extends StatelessWidget {
  final List<_InfoRow> rows;

  const _InfoTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      children: rows
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      r.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: r.onTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r.value,
                            style: TextStyle(
                              fontSize: r.onTap != null ? 13 : 12,
                              fontWeight: FontWeight.w500,
                              color: r.onTap != null
                                  ? AppColors.primaryGreen
                                  : AppColors.lightTextPrimary,
                            ),
                          ),

                          if (r.trailing != null) r.trailing!,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
