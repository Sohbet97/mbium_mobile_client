import 'coin_number_parsing.dart';

class MyCoinModel {
  final double balance;
  final double totalEarned;
  final double totalSpent;

  const MyCoinModel({
    required this.balance,
    required this.totalEarned,
    required this.totalSpent,
  });

  factory MyCoinModel.fromJson(Map<String, dynamic> json) {
    return MyCoinModel(
      balance: parseCoinDouble(json['balance']),
      totalEarned: parseCoinDouble(json['total_earned']),
      totalSpent: parseCoinDouble(json['total_spent']),
    );
  }
}
