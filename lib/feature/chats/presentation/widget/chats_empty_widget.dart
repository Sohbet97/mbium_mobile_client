import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ChatsEmptyWidget extends StatelessWidget {
  const ChatsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.description_outlined,
                size: 48, color: AppColors.textLightGrey),
            const SizedBox(height: 12),
            Text(
              l10n.habar_yok,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textLightGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}