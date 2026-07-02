import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../widgets/gorag_section_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class YnamdarToleglerPage extends StatelessWidget {
  const YnamdarToleglerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    const descStyle = TextStyle(
      fontSize: 13,
      color: AppColors.lightTextSecondary,
      height: 1.5,
    );

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
              l10n.ynamdar_tolegler,
              style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(l10n.ynamdar_tolegler_desc, style: descStyle),
            const SizedBox(height: 20),

            GoragSectionWidget(
              icon: Icons.credit_card_outlined,
              iconColor: AppColors.primaryGreen,
              title: l10n.durli_gornushli_tolog_usullary,
              children: [
                Text(l10n.durli_gornushli_desc, style: descStyle),
                const SizedBox(height: 8),
                Text(l10n.alternatiw_hokumde, style: descStyle),
                const SizedBox(height: 8),
                Text(l10n.pul, style: descStyle),
              ],
            ),
            const SizedBox(height: 16),

            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PayBadge('VISA'),
                _PayBadge('Mastercard'),
                _PayBadge('Amex'),
                _PayBadge('Apple Pay'),
                _PayBadge('Klarna'),
                _PayBadge('Afterpay'),
                _PayBadge('Pay Later'),
                _PayBadge('GPay'),
                _PayBadge('Discover'),
                _PayBadge('Diners'),
                _PayBadge('JCB'),
                _PayBadge('UnionPay'),
                _PayBadge('T/T'),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _PayBadge extends StatelessWidget {
  final String label;
  const _PayBadge(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.navBarGrey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}