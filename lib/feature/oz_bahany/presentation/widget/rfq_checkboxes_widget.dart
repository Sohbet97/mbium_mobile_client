import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class RfqCheckboxesWidget extends StatefulWidget {
  const RfqCheckboxesWidget({super.key});

  @override
  State<RfqCheckboxesWidget> createState() => _RfqCheckboxesWidgetState();
}

class _RfqCheckboxesWidgetState extends State<RfqCheckboxesWidget> {
  bool _check1 = false;
  bool _check2 = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Column(
      children: [
        _buildCheckbox(
          value: _check1,
          onChanged: (val) => setState(() => _check1 = val ?? false),
          text: l10n.rfq_checkbox1,
        ),
        const SizedBox(height: 8),
        _buildCheckbox(
          value: _check2,
          onChanged: (val) => setState(() => _check2 = val ?? false),
          text: l10n.rfq_checkbox2,
        ),
      ],
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.bonusBannerTextGreen
                : AppColors.navBarGrey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.lightTextSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}