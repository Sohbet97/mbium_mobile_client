import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class SupportLiveChatButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const SupportLiveChatButtonWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFF2E86FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.navWhite,
              child: Icon(Icons.support_agent, color: AppColors.primaryGreen, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.janly_sohbetdeslik,
              style: const TextStyle(
                color: AppColors.navWhite,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}