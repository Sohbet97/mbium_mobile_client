import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/category/extensions/category_extensions.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';
import 'package:mbium_mobile_client/feature/shops/presentation/widget/shop_detail_categories_sheet_widget.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailAboutTabWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailAboutTabWidget({super.key, required this.model});

  void _openCategoriesSheet(BuildContext context, String languageCode) {
    ShopDetailCategoriesSheetWidget.show(
      context,
      model: model,
      languageCode: languageCode,
    );
  }

  Future<void> _openMap() async {
    final coords = model.coordinates;
    if (coords?.lat == null || coords?.lng == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${coords!.lat},${coords.lng}',
    );
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;
    final languageCode = context.read<MainBloc>().state.languageCode;
    final description = model.localizedDescription;

    final categoriesLabel = model.categories.isEmpty
        ? l10n.kategoriya_yok
        : model.categories
              .map((e) => e.getNameByLanguage(languageCode))
              .join(', ');

    final hasCoordinates =
        model.coordinates?.lat != null && model.coordinates?.lng != null;

    final items = <_AboutItem>[
      if (model.address != null && model.address!.isNotEmpty)
        _AboutItem(
          icon: Icons.location_on_outlined,
          label: l10n.yeri,
          value: model.address!,
        ),
      if (model.location != null &&
          model.location!.isNotEmpty &&
          model.location != model.address)
        _AboutItem(
          icon: Icons.map_outlined,
          label: l10n.yerleshishi,
          value: model.location!,
        ),
      if (hasCoordinates)
        _AboutItem(
          icon: Icons.pin_drop_outlined,
          label: l10n.kartada_gorkez,
          value: '${model.coordinates!.lat}, ${model.coordinates!.lng}',
          onTap: _openMap,
        ),
      if (model.type?.name != null)
        _AboutItem(
          icon: Icons.store_outlined,
          label: l10n.dukanyn_gornushi,
          value: model.type!.name!,
        ),
      _AboutItem(
        icon: Icons.category_outlined,
        label: l10n.kategoriyalar,
        value: categoriesLabel,
        onTap: () => _openCategoriesSheet(context, languageCode),
      ),

      if (model.isActive != null)
        _AboutItem(
          icon: model.isActive == true
              ? Icons.check_circle_outline
              : Icons.pause_circle_outlined,
          label: l10n.iyleyish_yagdayy,
          value: model.isActive == true ? l10n.isleyar : l10n.islemeyar,
        ),
    ];

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: model.isVerified == true
                ? AppColors.bonusBannerTextGreen.withValues(alpha: 0.08)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: model.isVerified == true
                  ? AppColors.bonusBannerTextGreen.withValues(alpha: 0.3)
                  : AppColors.navBarGrey,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color:
                      (model.isVerified == true
                              ? AppColors.bonusBannerTextGreen
                              : AppColors.lightTextSecondary)
                          .withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  model.isVerified == true
                      ? Icons.verified
                      : Icons.error_outline,
                  color: model.isVerified == true
                      ? AppColors.bonusBannerTextGreen
                      : AppColors.lightTextSecondary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.isVerified == true
                          ? l10n.tassyklanan_dukan
                          : l10n.tassyklanmadyk_dukan,
                      style: textStyles.s13w600clBlack,
                    ),
                    if (model.verificationNote != null &&
                        model.verificationNote!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        model.verificationNote!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (description.isNotEmpty) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.dukan_barada, style: textStyles.s13w600clBlack),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.lightTextSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final item = e.value;
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: item.onTap,
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: AppColors.lightTextSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.label,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.value,
                                  style: textStyles.s13w600clBlack,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (item.onTap != null)
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.lightTextSecondary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 14, endIndent: 14),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _AboutItem {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _AboutItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });
}
