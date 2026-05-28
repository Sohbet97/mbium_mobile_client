import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ShopsSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTapPhoto;
  final VoidCallback? onTapAudio;
  final VoidCallback? onTapAi;
  final VoidCallback? onSubmit;

  const ShopsSearchWidget({
    super.key,
    required this.controller,
    this.onTapPhoto,
    this.onTapAudio,
    this.onTapAi,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.navBarGrey),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onTapPhoto,
              child: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.textLightGrey, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onSubmit?.call(),
                decoration: InputDecoration(
                  hintText: l10n.search,
                  hintStyle: const TextStyle(
                    color: AppColors.textLightGrey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTapAudio,
              child: const Icon(Icons.mic_outlined,
                  color: AppColors.textLightGrey, size: 20),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onTapAi,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}