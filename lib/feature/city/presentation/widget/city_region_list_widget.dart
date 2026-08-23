import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/myMbium/data/location_repository.dart';
import 'package:mbium_mobile_client/feature/myMbium/models/location_model.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../generated/l10n.dart';

/// Horizontal, pill-shaped list of regions fetched from [LocationRepository]
/// — lets the user pick a region to browse the city page by, mirroring the
/// look of [CityCategoryTabsWidget]. The fetch happens once in [initState]
/// so rebuilding the page (e.g. via `setState` for filters) doesn't refire
/// the request.
class CityRegionListWidget extends StatefulWidget {
  final ValueChanged<RegionModel?>? onRegionSelected;

  const CityRegionListWidget({super.key, this.onRegionSelected});

  @override
  State<CityRegionListWidget> createState() => _CityRegionListWidgetState();
}

class _CityRegionListWidgetState extends State<CityRegionListWidget> {
  late final Future<({List<RegionModel> items, int count})> _regionsFuture;
  int? _selectedRegionId;

  @override
  void initState() {
    super.initState();
    _regionsFuture = context.read<LocationRepository>().getRegions();
  }

  void _handleSelect(RegionModel? region) {
    setState(() => _selectedRegionId = region?.id);
    widget.onRegionSelected?.call(region);
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    return FutureBuilder<({List<RegionModel> items, int count})>(
      future: _regionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _ShimmerEffect();
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final regions = snapshot.data!.items;
        if (regions.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 30,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: regions.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildItem(
                  localization.ahlisi,
                  () => _handleSelect(null),
                  _selectedRegionId == null,
                );
              }

              final region = regions[index - 1];
              return _buildItem(
                region.name,
                () => _handleSelect(region),
                _selectedRegionId == region.id,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildItem(String name, VoidCallback onSelect, bool isSelected) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondaryGreen.withValues(alpha: 0.8)
              : AppColors.navBarGrey,
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.secondaryGreen.withValues(alpha: 0.8),
                    AppColors.secondaryGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? AppColors.navWhite : AppColors.aiTextBlack,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _ShimmerEffect extends StatelessWidget {
  const _ShimmerEffect();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 30,
        child: ListView.builder(
          itemCount: 6,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.surface,
              highlightColor: AppColors.lightBg,
              child: Container(
                width: 90,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
