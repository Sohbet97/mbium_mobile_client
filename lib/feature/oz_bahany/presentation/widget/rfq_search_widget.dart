import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class RfqSearchWidget extends StatelessWidget {
  final TextEditingController controller;

  const RfqSearchWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: l10n.search,
        hintStyle: const TextStyle(
          color: AppColors.textLightGrey,
          fontSize: 14,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close,
                    color: AppColors.textLightGrey, size: 20),
                onPressed: () => controller.clear(),
              )
            : null,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navBarGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navBarGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}