import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ChatsFilterWidget extends StatefulWidget {
  const ChatsFilterWidget({super.key});

  @override
  State<ChatsFilterWidget> createState() => _ChatsFilterWidgetState();
}

class _ChatsFilterWidgetState extends State<ChatsFilterWidget> {
  bool _unreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() => _unreadOnly = !_unreadOnly),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _unreadOnly
                    ? AppColors.primaryGreen.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _unreadOnly
                      ? AppColors.primaryGreen
                      : AppColors.textLightGrey.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                l10n.okalmanlar,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _unreadOnly
                      ? AppColors.primaryGreen
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.textLightGrey.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Text(
                  l10n.menin_belgim,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    size: 16, color: AppColors.lightTextSecondary),
              ],
            ),
          ),
          const Spacer(),
          const Icon(Icons.delete_outline,
              size: 22, color: AppColors.lightTextSecondary),
        ],
      ),
    );
  }
}