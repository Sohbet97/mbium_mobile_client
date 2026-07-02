import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class KepillendirillenGowsuryshPage extends StatelessWidget {
  const KepillendirillenGowsuryshPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.gorag, style: textStyles.s16w600clBlack),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.kepillendirilen_gowsurysh,
              style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.kepillendirilen_gowsurysh_desc,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            Center(
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  l10n.sertler_we_kadalar,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightTextSecondary,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}