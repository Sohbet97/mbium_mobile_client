import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/myMbium/bloc/address_bloc.dart';
import 'package:mbium_mobile_client/feature/myMbium/data/location_repository.dart';
import 'package:mbium_mobile_client/feature/myMbium/models/address_model.dart';
import 'package:mbium_mobile_client/feature/myMbium/models/location_model.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/addresses/widgets/location_picker_page.dart';
import 'package:mbium_mobile_client/feature/myMbium/presentation/addresses/widgets/location_picker_sheet.dart';

import '../../../../../generated/l10n.dart';

class AddressFormSheet extends StatefulWidget {
  const AddressFormSheet({super.key, this.initial});

  final AddressModel? initial;

  static Future<void> show(BuildContext context, {AddressModel? initial}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => SafeArea(
        child: BlocProvider.value(
          value: context.read<AddressBloc>(),
          child: AddressFormSheet(initial: initial),
        ),
      ),
    );
  }

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _labelController = TextEditingController(
    text: widget.initial?.label,
  );
  late final _addressController = TextEditingController(
    text: widget.initial?.address,
  );
  late bool _isDefault = widget.initial?.isDefault ?? false;

  double? _lat;
  double? _lng;

  // The address model only carries ids, not names — until the user actively
  // (re)picks one, an edited address just shows "ID: n" as a placeholder
  // since there's no "get by id" endpoint to resolve the name up front.
  late int? _regionId = widget.initial?.regionId;
  String? _regionName;
  late int? _cityId = widget.initial?.cityId;
  String? _cityName;

  bool get _isEditing => widget.initial != null;
  bool get _hasLocation => _lat != null && _lng != null;

  @override
  void initState() {
    super.initState();
    final coordinates = widget.initial?.coordinates;
    if (coordinates != null && (coordinates.lat != 0 || coordinates.lng != 0)) {
      _lat = coordinates.lat;
      _lng = coordinates.lng;
    }
  }

  Future<void> _pickRegion() async {
    final region = await LocationPickerSheet.show<RegionModel>(
      context,
      title: 'Sebiti saýlaň',
      fetch: (text) =>
          context.read<LocationRepository>().getRegions(text: text),
      labelOf: (r) => r.name,
    );
    if (region == null) return;
    setState(() {
      _regionId = region.id;
      _regionName = region.name;
      // Cities are scoped to a region — switching region invalidates
      // whatever city was previously picked.
      _cityId = null;
      _cityName = null;
    });
  }

  Future<void> _pickCity() async {
    final regionId = _regionId;
    if (regionId == null) return;

    final city = await LocationPickerSheet.show<CityModel>(
      context,
      title: 'Şäheri saýlaň',
      fetch: (text) => context.read<LocationRepository>().getCities(
        text: text,
        regionId: regionId,
      ),
      labelOf: (c) => c.name,
    );
    if (city == null) return;
    setState(() {
      _cityId = city.id;
      _cityName = city.name;
    });
  }

  Future<void> _pickOnMap() async {
    final picked = await LocationPickerPage.show(
      context,
      initial: _hasLocation ? LatLng(_lat!, _lng!) : null,
    );
    if (picked == null) return;
    setState(() {
      _lat = picked.latitude;
      _lng = picked.longitude;
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final regionId = _regionId;
    final cityId = _cityId;
    if (regionId == null || cityId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sebit we şäheri saýlaň')));
      return;
    }

    final localization = S.of(context);
    if (!_hasLocation) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.address_location_required)),
      );
      return;
    }

    final address = AddressModel(
      id: widget.initial?.id ?? 0,
      userId: widget.initial?.userId ?? '',
      label: _labelController.text.trim(),
      address: _addressController.text.trim(),
      cityId: cityId,
      regionId: regionId,
      coordinates: AddressCoordinates(lat: _lat!, lng: _lng!),
      isDefault: _isDefault,
      createdAt: widget.initial?.createdAt,
    );

    if (_isEditing) {
      context.read<AddressBloc>().add(UpdateAddressEvent(address.id, address));
    } else {
      context.read<AddressBloc>().add(AddAddressEvent(address));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetColor = isDark ? AppColors.darkBg : AppColors.lightBg;

    return Container(
      decoration: BoxDecoration(
        color: sheetColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _isEditing
                          ? localization.address_edit
                          : localization.address_new,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SectionCard(
                isDark: isDark,
                children: [
                  TextFormField(
                    controller: _labelController,
                    decoration: InputDecoration(
                      labelText: localization.address_label_hint,
                      prefixIcon: const Icon(Icons.bookmark_outline_rounded),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? localization.address_label_required
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: localization.address_field_hint,
                      prefixIcon: const Icon(Icons.home_outlined),
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? localization.address_field_required
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SectionCard(
                isDark: isDark,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _LocationSelectorField(
                          label: 'Sebit',
                          icon: Icons.map_outlined,
                          value:
                              _regionName ??
                              (_regionId != null ? 'ID: $_regionId' : null),
                          onTap: _pickRegion,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _LocationSelectorField(
                          label: 'Şäher',
                          icon: Icons.location_city_outlined,
                          value:
                              _cityName ??
                              (_cityId != null ? 'ID: $_cityId' : null),
                          onTap: _regionId == null ? null : _pickCity,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _MapPickerTile(
                    isDark: isDark,
                    hasLocation: _hasLocation,
                    onTap: _pickOnMap,
                    label: _hasLocation
                        ? localization.address_location_selected
                        : localization.address_choose_location,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _SectionCard(
                isDark: isDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: AppColors.primaryGreen,
                    title: Text(
                      localization.address_set_default,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    secondary: const Icon(
                      Icons.star_outline_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    value: _isDefault,
                    onChanged: (value) => setState(() => _isDefault = value),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(
                    _isEditing ? localization.address_save : localization.add,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded, softly-shadowed grouping container used to give the form a
/// premium, card-based feel instead of a flat list of bare fields.
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.isDark,
    required this.children,
    this.padding = const EdgeInsets.all(16),
  });

  final bool isDark;
  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

/// Tappable card that opens the map picker. Only ever shows a human-readable
/// status ("choose on map" / "location selected") — the raw lat/lng is kept
/// internally for the request payload but never rendered.
class _MapPickerTile extends StatelessWidget {
  const _MapPickerTile({
    required this.isDark,
    required this.hasLocation,
    required this.onTap,
    required this.label,
  });

  final bool isDark;
  final bool hasLocation;
  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: hasLocation
                ? AppColors.primaryGreen
                : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
            width: hasLocation ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasLocation ? Icons.location_on : Icons.map_outlined,
                color: AppColors.primaryGreen,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              hasLocation
                  ? Icons.check_circle_rounded
                  : Icons.chevron_right_rounded,
              color: hasLocation
                  ? AppColors.primaryGreen
                  : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mimics a [TextFormField]'s chrome (label, border) but opens
/// [LocationPickerSheet] on tap instead of accepting direct text input.
class _LocationSelectorField extends StatelessWidget {
  const _LocationSelectorField({
    required this.label,
    required this.value,
    required this.onTap,
    this.icon,
  });

  final String label;
  final String? value;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          prefixIcon: icon != null ? Icon(icon) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? '—',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: value == null ? Colors.grey : null),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: enabled ? null : Colors.grey),
          ],
        ),
      ),
    );
  }
}
