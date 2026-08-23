import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
  late final _latController = TextEditingController(
    text: widget.initial?.coordinates.lat.toString(),
  );
  late final _lngController = TextEditingController(
    text: widget.initial?.coordinates.lng.toString(),
  );
  late bool _isDefault = widget.initial?.isDefault ?? false;

  // The address model only carries ids, not names — until the user actively
  // (re)picks one, an edited address just shows "ID: n" as a placeholder
  // since there's no "get by id" endpoint to resolve the name up front.
  late int? _regionId = widget.initial?.regionId;
  String? _regionName;
  late int? _cityId = widget.initial?.cityId;
  String? _cityName;

  bool get _isEditing => widget.initial != null;

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
    final currentLat = double.tryParse(_latController.text);
    final currentLng = double.tryParse(_lngController.text);
    final picked = await LocationPickerPage.show(
      context,
      initial: currentLat != null && currentLng != null
          ? LatLng(currentLat, currentLng)
          : null,
    );
    if (picked == null) return;
    setState(() {
      _latController.text = picked.latitude.toString();
      _lngController.text = picked.longitude.toString();
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _latController.dispose();
    _lngController.dispose();
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

    final address = AddressModel(
      id: widget.initial?.id ?? 0,
      userId: widget.initial?.userId ?? '',
      label: _labelController.text.trim(),
      address: _addressController.text.trim(),
      cityId: cityId,
      regionId: regionId,
      coordinates: AddressCoordinates(
        lat: double.tryParse(_latController.text) ?? 0,
        lng: double.tryParse(_lngController.text) ?? 0,
      ),
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
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
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
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _isEditing
                    ? localization.address_edit
                    : localization.address_new,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  labelText: localization.address_label_hint,
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? localization.address_label_required
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: localization.address_field_hint,
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? localization.address_field_required
                    : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LocationSelectorField(
                      label: 'Sebit',
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
                      value:
                          _cityName ??
                          (_cityId != null ? 'ID: $_cityId' : null),
                      onTap: _regionId == null ? null : _pickCity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickOnMap,
                  icon: const Icon(Icons.map_outlined),
                  label: Text(localization.address_choose_location),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: localization.address_latitude,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lngController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      decoration: InputDecoration(
                        labelText: localization.address_longitude,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(localization.address_set_default),
                value: _isDefault,
                onChanged: (value) => setState(() => _isDefault = value),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text(
                    _isEditing ? localization.address_save : localization.add,
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

/// Mimics a [TextFormField]'s chrome (label, border) but opens
/// [LocationPickerSheet] on tap instead of accepting direct text input.
class _LocationSelectorField extends StatelessWidget {
  const _LocationSelectorField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, enabled: enabled),
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
