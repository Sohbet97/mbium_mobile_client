import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

Future<void> showProfileChangePasswordDialog(BuildContext context) {
  final oldController = TextEditingController();
  final newController = TextEditingController();
  final l10n = S.of(context);

  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.paroly_uytgetmek),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.koni_parol,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.taze_parol,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.yatyr, style: const TextStyle(color: AppColors.lightTextSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.parol_uytgedildi)),
              );
            },
            child: Text(l10n.ok_diyip_tassykla, style: const TextStyle(color: AppColors.primaryGreen)),
          ),
        ],
      );
    },
  );
}