class MyCoinModel {
  final int balance;
  final int totalEarned;
  final int totalSpent;

  const MyCoinModel({
    required this.balance,
    required this.totalEarned,
    required this.totalSpent,
  });

  factory MyCoinModel.fromJson(Map<String, dynamic> json) {
    return MyCoinModel(
      balance: json['balance'] as int? ?? 0,
      totalEarned: json['total_earned'] as int? ?? 0,
      totalSpent: json['total_spent'] as int? ?? 0,
    );
  }
}
