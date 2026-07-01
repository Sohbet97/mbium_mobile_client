import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/shops/bloc/shop_bloc.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_type_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_type_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../generated/l10n.dart';

class ShopsFilterChipsWidget extends StatefulWidget {
  final ValueChanged<int?>? onTypeSelected;

  const ShopsFilterChipsWidget({super.key, this.onTypeSelected});

  @override
  State<ShopsFilterChipsWidget> createState() => _ShopsFilterChipsWidgetState();
}

class _ShopsFilterChipsWidgetState extends State<ShopsFilterChipsWidget> {
  int? _selectedTypeId;

  @override
  void initState() {
    super.initState();
    context.read<ShopBloc>().add(const GetShopTypesEvent());
  }

  void _onSelect(int? typeId) {
    setState(() {
      _selectedTypeId = typeId;
    });
    widget.onTypeSelected?.call(_selectedTypeId);
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (previous, current) =>
          current is GetShopTypesSuccess || current is GetShopTypesError,
      builder: (context, state) {
        if (state is GetShopTypesError) return const SizedBox.shrink();

        if (state is GetShopTypesSuccess) {
          if (state.shopTypes.isEmpty) return const SizedBox.shrink();

          final shopTypes = [
            ShopTypeModel(
              id: null,
              name: localization.all,
              nameRu: localization.all,
              nameEng: localization.all,
            ),
            ...state.shopTypes,
          ];

          return SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: shopTypes.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final type = shopTypes[i];
                final isSelected = _selectedTypeId == type.id;

                return GestureDetector(
                  onTap: () => _onSelect(type.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.navBarGrey,
                      ),
                    ),
                    child: Text(
                      type.localizedName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        return const _ShimmerEffect();
      },
    );
  }
}

class _ShimmerEffect extends StatelessWidget {
  const _ShimmerEffect();

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          return Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 90,
              height: 28,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }
}
