import 'coin_number_parsing.dart';

class CoinHistoryModel {
  final int id;
  final double amount;
  final String type;
  final String source;
  final String? referenceId;
  final double balanceAfter;
  final String? note;
  final DateTime createdAt;

  const CoinHistoryModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.source,
    this.referenceId,
    required this.balanceAfter,
    this.note,
    required this.createdAt,
  });

  factory CoinHistoryModel.fromJson(Map<String, dynamic> json) {
    return CoinHistoryModel(
      id: json['id'] as int,
      amount: parseCoinDouble(json['amount']),
      type: json['type'] as String? ?? '',
      source: json['source'] as String? ?? '',
      referenceId: json['reference_id'] as String?,
      balanceAfter: parseCoinDouble(json['balance_after']),
      note: json['note'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }
}
