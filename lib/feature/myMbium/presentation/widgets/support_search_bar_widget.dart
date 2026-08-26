import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class SupportSearchBarWidget extends StatelessWidget {
  const SupportSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.lightTextSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.support_search_hint,
              style: const TextStyle(fontSize: 14, color: AppColors.lightTextSecondary),
            ),
          ),
        ],
      ),
    );
  }
}