import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class RfqQuantityWidget extends StatefulWidget {
  const RfqQuantityWidget({super.key});

  @override
  State<RfqQuantityWidget> createState() => _RfqQuantityWidgetState();
}

class _RfqQuantityWidgetState extends State<RfqQuantityWidget> {
  final _quantityController = TextEditingController();
  String _selectedUnit = 'sany';

  final List<String> _units = ['sany', 'kg', 'litr', 'm', 'sm'];

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: '* ',
                style: TextStyle(color: AppColors.errorRed, fontSize: 14),
              ),
              TextSpan(
                text: l10n.mocberi_girizin,
                style: textStyles.s13w600clBlack,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: l10n.mocberi_girizin,
                  hintStyle: const TextStyle(
                    color: AppColors.textLightGrey,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.navBarGrey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.navBarGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primaryGreen),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.navBarGrey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedUnit,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.lightTextSecondary),
                  items: _units.map((unit) {
                    return DropdownMenuItem(
                      value: unit,
                      child: Text(unit,
                          style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (val) =>
                      setState(() => _selectedUnit = val ?? 'sany'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}