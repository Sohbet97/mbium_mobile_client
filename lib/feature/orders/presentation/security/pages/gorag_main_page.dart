import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/orders/presentation/security/pages/ynamdar_tolegler_page.dart';
import 'package:mbium_mobile_client/feature/orders/presentation/security/pages/kepillendirilen_gowsurysh_page.dart';
import 'package:mbium_mobile_client/feature/orders/presentation/security/pages/biz_size_komek_page.dart';
import 'package:mbium_mobile_client/feature/orders/presentation/security/pages/gije_gundizleyin_goldaw_page.dart';
import 'package:mbium_mobile_client/feature/orders/presentation/security/pages/maglumatlar_gizlinligi_page.dart';
import 'package:mbium_mobile_client/feature/orders/presentation/security/widgets/gorag_section_widget.dart';
import 'package:mbium_mobile_client/feature/orders/presentation/security/widgets/gorag_link_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class GoragMainPage extends StatelessWidget {
  const GoragMainPage({super.key});

  void _openPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Widget _boldLeadText(
      String text, TextStyle boldStyle, TextStyle normalStyle) {
    final colonIndex = text.indexOf(':');
    if (colonIndex == -1) {
      return Text(text, style: normalStyle);
    }
    final lead = text.substring(0, colonIndex + 1);
    final rest = text.substring(colonIndex + 1);
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: lead, style: boldStyle),
          TextSpan(text: rest, style: normalStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    const descStyle = TextStyle(
      fontSize: 13,
      color: AppColors.lightTextSecondary,
      height: 1.5,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.alibaba_sargyt_goragy,
            style: textStyles.s16w600clBlack.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 20),

          // 1. Sargydyňyzy nädip gorap bilersiňiz
          GoragSectionWidget(
            icon: Icons.location_on_outlined,
            iconColor: AppColors.primaryGreen,
            title: l10n.sargydynyz_nadip_gorap_bilersiniz,
            children: [
              Text(
                l10n.onuniz_ozuniz_alynyz_goragy,
                style: textStyles.s13w600clBlack,
              ),
              const SizedBox(height: 6),
              Text(l10n.sargyt_gorag_desc1, style: descStyle),
              const SizedBox(height: 12),
              _boldLeadText(
                l10n.kogda_desk,
                textStyles.s13w600clBlack,
                descStyle,
              ),
            ],
          ),
          const SizedBox(height: 16),

// Howpsuz tölegler — töleg logolary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: AppColors.primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.hopwsuz_toleg, style: textStyles.s13w600clBlack),
                  ],
                ),
                const SizedBox(height: 10),
                Text(l10n.hopwsuz_toleg_des, style: descStyle),
                const SizedBox(height: 8),
                Text(l10n.hopwsuz_toleg_deskk, style: descStyle),
                const SizedBox(height: 12),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PaymentBadge('VISA'),
                    _PaymentBadge('Mastercard'),
                    _PaymentBadge('Amex'),
                    _PaymentBadge('PayPal'),
                    _PaymentBadge('Klarna'),
                    _PaymentBadge('Afterpay'),
                    _PaymentBadge('Pay Later'),
                    _PaymentBadge('GPay'),
                    _PaymentBadge('Discover'),
                    _PaymentBadge('Diners'),
                    _PaymentBadge('JCB'),
                    _PaymentBadge('UnionPay'),
                    _PaymentBadge('T/T'),
                  ],
                ),
                const SizedBox(height: 10),
                GoragLinkWidget(
                  text: l10n.howpsuz_tolegler_has_ginisleyin,
                  onTap: () => _openPage(context, const YnamdarToleglerPage()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Kepillendirilen gowşuryş
          GoragSectionWidget(
            icon: Icons.local_shipping_outlined,
            iconColor: AppColors.primaryGreen,
            title: l10n.kepillendirilen_gowsurysh,
            children: [
              Text(l10n.bash_zakaz, style: descStyle),
              const SizedBox(height: 8),
              Text(l10n.redkih, style: descStyle),
              const SizedBox(height: 8),
              GoragLinkWidget(
                text: l10n.podrobnoye,
                onTap: () =>
                    _openPage(context, const KepillendirillenGowsuryshPage()),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Töleg gaýtarmak goragy
          GoragSectionWidget(
            icon: Icons.currency_exchange_outlined,
            iconColor: AppColors.primaryGreen,
            title: l10n.tolog_gaytarmak_goragy,
            children: [
              Text(l10n.tolog_gaytarmak_desc, style: descStyle),
              const SizedBox(height: 8),
              GoragLinkWidget(
                text: l10n.haryt_gaytarmak,
                onTap: () => _openPage(context, const BizSizeKomekPage()),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Gije-gündizleýin goldaw
          GoragSectionWidget(
            icon: Icons.support_agent_outlined,
            iconColor: AppColors.primaryGreen,
            title: l10n.gije_gundizleyin_goldaw_title,
            children: [
              Text(l10n.gije_gundizleyin_goldaw_desc, style: descStyle),
              const SizedBox(height: 8),
              GoragLinkWidget(
                text: l10n.has_ginisleyin,
                onTap: () =>
                    _openPage(context, const GijeGundizleyinGoldawPage()),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 5. Maglumatlarýň gizlinligi
          GoragSectionWidget(
            icon: Icons.lock_outline,
            iconColor: AppColors.primaryGreen,
            title: l10n.maglumatlaryn_gizlinligi,
            children: [
              Text(l10n.maglumatlaryn_gizlinligi_desc, style: descStyle),
              const SizedBox(height: 8),
              GoragLinkWidget(
                text: l10n.has_ginisleyin,
                onTap: () =>
                    _openPage(context, const MaglumatlarGizlinligiPage()),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String label;
  const _PaymentBadge(this.label);

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