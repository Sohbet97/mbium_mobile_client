import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';

class ReelsResponse {
  final List<ReelsModel> reels;
  final int count;

  const ReelsResponse({
    required this.reels,
    required this.count,
  });

  bool hasMore(int page, int limit) => page * limit < count;

  factory ReelsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];

    return ReelsResponse(
      reels: data
          .map((e) => ReelsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: json['count'] as int? ?? data.length,
    );
  }
}
