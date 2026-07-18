import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_history_model.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_topup_model.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../generated/l10n.dart';

/// Gradient hero header showing the current MBIUM coin balance, styled
/// after the "hero + overlapping sheet" pattern used elsewhere in the app.
class CoinBalanceHeader extends StatelessWidget {
  const CoinBalanceHeader({
    super.key,
    required this.balance,
    required this.isLoading,
    required this.onTopUp,
  });

  final double? balance;
  final bool isLoading;
  final VoidCallback onTopUp;

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff187443), Color(0xff5FA67E)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.coin_balance_title,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/coin_image.png',
                          height: 32,
                          width: 32,
                        ),
                        const SizedBox(width: 10),
                        isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _formatAmount(balance ?? 0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: onTopUp,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_circle_outline,
                              size: 18,
                              color: AppColors.primaryGreen,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              loc.balans_doldurmak,
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatAmount(double value) {
  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
}

/// Single row rendering a [CoinHistoryModel] transaction.
class CoinHistoryTile extends StatelessWidget {
  const CoinHistoryTile({super.key, required this.item});

  final CoinHistoryModel item;

  // The API doesn't document a fixed enum for `type`; known values seen so
  // far are EARN (docs example) and GRANT (real topup-approval payload).
  static const _debitTypes = {
    'SPEND',
    'PURCHASE',
    'DEDUCT',
    'PENALTY',
    'WITHDRAW',
    'DEBIT',
  };

  bool get _isPositive => !_debitTypes.contains(item.type.toUpperCase());

  @override
  Widget build(BuildContext context) {
    final color = _isPositive ? AppColors.successGreen : AppColors.errorRed;
    final sign = _isPositive ? '+' : '-';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isPositive ? Icons.arrow_downward : Icons.arrow_upward,
          color: color,
          size: 20,
        ),
      ),
      title: Text(
        item.source,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        DateFormat('dd.MM.yyyy HH:mm').format(item.createdAt),
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Text(
        '$sign${_formatAmount(item.amount)}',
        style: TextStyle(fontWeight: FontWeight.w700, color: color, fontSize: 15),
      ),
    );
  }
}

/// Single row rendering a [CoinTopupModel] top-up request.
class CoinTopupTile extends StatelessWidget {
  const CoinTopupTile({super.key, required this.item});

  final CoinTopupModel item;

  Color _statusColor() {
    switch (item.status.toUpperCase()) {
      case 'APPROVED':
        return AppColors.successGreen;
      case 'REJECTED':
        return AppColors.errorRed;
      default:
        return Colors.orange;
    }
  }

  String _statusLabel(S loc) {
    switch (item.status.toUpperCase()) {
      case 'APPROVED':
        return loc.status_approved;
      case 'REJECTED':
        return loc.status_rejected;
      default:
        return loc.status_pending;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    final color = _statusColor();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.account_balance_wallet_outlined, color: color, size: 20),
      ),
      title: Text(
        '${_formatAmount(item.amountTmt)} TMT',
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        item.createdAt != null
            ? DateFormat('dd.MM.yyyy HH:mm').format(item.createdAt!)
            : '',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _statusLabel(loc),
          style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 11),
        ),
      ),
    );
  }
}

/// Bottom sheet form used to submit a [SubmitCoinTopupEvent]-style request:
/// amount in TMT + an optional receipt URL.
class CoinTopupSheet extends StatefulWidget {
  const CoinTopupSheet({super.key, required this.isSubmitting, required this.onSubmit});

  final bool isSubmitting;
  final void Function(double amountTmt, String? receiptUrl) onSubmit;

  @override
  State<CoinTopupSheet> createState() => _CoinTopupSheetState();
}

class _CoinTopupSheetState extends State<CoinTopupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _receiptController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _receiptController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null) return;
    widget.onSubmit(
      amount,
      _receiptController.text.trim().isEmpty
          ? null
          : _receiptController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = S.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              loc.balans_doldurmak,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: loc.coin_amount_tmt,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              validator: (value) {
                final amount = double.tryParse((value ?? '').trim());
                if (amount == null || amount <= 0) return loc.hokmany;
                return null;
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _receiptController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: loc.coin_receipt_url,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: widget.isSubmitting ? null : _submit,
              child: widget.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Text(loc.ugrat, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer placeholder matching the shape of [CoinHistoryTile]/[CoinTopupTile].
class CoinTileShimmer extends StatelessWidget {
  const CoinTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
