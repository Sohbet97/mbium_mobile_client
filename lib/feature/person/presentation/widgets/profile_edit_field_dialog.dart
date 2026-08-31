import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

Future<String?> showProfileEditFieldDialog(
  BuildContext context, {
  required String title,
  required String initialValue,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
}) {
  final controller = TextEditingController(text: initialValue);
  final l10n = S.of(context);

  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.yatyr, style: const TextStyle(color: AppColors.lightTextSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: Text(l10n.ok_diyip_tassykla, style: const TextStyle(color: AppColors.primaryGreen)),
          ),
        ],
      );
    },
  );
}