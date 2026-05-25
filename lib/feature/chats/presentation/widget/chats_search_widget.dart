import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ChatsSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;

  const ChatsSearchWidget({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: l10n.habarlary_gozle,
          hintStyle: const TextStyle(
            fontSize: 13,
            color: AppColors.textLightGrey,
          ),
          prefixIcon: const Icon(Icons.search,
              color: AppColors.textLightGrey, size: 20),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}