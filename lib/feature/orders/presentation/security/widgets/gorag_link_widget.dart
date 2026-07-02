import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class GoragLinkWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const GoragLinkWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.primaryGreen,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.primaryGreen,
        ),
      ),
    );
  }
}