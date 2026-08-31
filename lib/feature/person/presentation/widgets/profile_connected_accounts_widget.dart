import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProfileConnectedAccountsWidget extends StatefulWidget {
  const ProfileConnectedAccountsWidget({super.key});

  @override
  State<ProfileConnectedAccountsWidget> createState() =>
      _ProfileConnectedAccountsWidgetState();
}

class _ProfileConnectedAccountsWidgetState
    extends State<ProfileConnectedAccountsWidget> {
  bool _googleConnected = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.birikdirilen_hasaplar, style: textStyles.s16w600clBlack),
        const SizedBox(height: 4),
        Text(
          l10n.birikdirilen_hasaplar_desc,
          style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: _AccountRow(
            icon: Icons.g_mobiledata,
            label: 'Google',
            connected: _googleConnected,
            onTap: () => setState(() => _googleConnected = !_googleConnected),
          ),
        ),
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool connected;
  final VoidCallback onTap;

  const _AccountRow({
    required this.icon,
    required this.label,
    required this.connected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.lightTextSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 14)),
            ),
            Text(
              connected ? l10n.birikdirildi : l10n.birikdirmek,
              style: TextStyle(
                fontSize: 13,
                color: connected ? AppColors.primaryGreen : AppColors.lightTextSecondary,
              ),
            ),
            if (!connected) ...[
              const SizedBox(width: 2),
              Icon(Icons.chevron_right, size: 18, color: Colors.grey.withValues(alpha: 0.6)),
            ],
          ],
        ),
      ),
    );
  }
}