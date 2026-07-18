import 'coin_number_parsing.dart';

class CoinTopupModel {
  final int id;
  final double amountTmt;
  final double coinsRequested;
  final String status;
  final String? receiptUrl;
  final String? note;
  final DateTime? createdAt;

  const CoinTopupModel({
    required this.id,
    required this.amountTmt,
    required this.coinsRequested,
    required this.status,
    this.receiptUrl,
    this.note,
    this.createdAt,
  });

  factory CoinTopupModel.fromJson(Map<String, dynamic> json) {
    return CoinTopupModel(
      id: json['id'] as int,
      amountTmt: parseCoinDouble(json['amount_tmt']),
      coinsRequested: parseCoinDouble(json['coins_requested']),
      status: json['status'] as String? ?? '',
      receiptUrl: json['receipt_url'] as String?,
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }
}
