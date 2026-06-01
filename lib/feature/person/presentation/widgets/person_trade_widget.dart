import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class PersonTradeWidget extends StatelessWidget {
  const PersonTradeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.sowda_maglumatlary,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 4),
            Text(l10n.sowda_maglumatlary_desc,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.lightTextSecondary)),
          ],
        ),
      ),
    );
  }
}