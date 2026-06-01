class ReelsModel {
  final int id;
  final String? titleTm;
  final String? titleRu;
  final String? titleEn;
  final String videoUrl;
  final int commentCount;
  final int shareCount;
  final int favoriteCount;
  final bool isLive;
  final int starCount;

  const ReelsModel({
    required this.id,
    this.titleTm,
    this.titleRu,
    this.titleEn,
    required this.videoUrl,
    required this.commentCount,
    required this.shareCount,
    required this.favoriteCount,
    required this.isLive,
    required this.starCount,
  });

  ReelsModel copyWith({
    int? id,
    String? titleTm,
    String? titleRu,
    String? titleEn,
    String? videoUrl,
    int? commentCount,
    int? shareCount,
    int? favoriteCount,
    bool? isLive,
    int? starCount,
  }) {
    return ReelsModel(
      id: id ?? this.id,
      titleTm: titleTm ?? this.titleTm,
      titleRu: titleRu ?? this.titleRu,
      titleEn: titleEn ?? this.titleEn,
      videoUrl: videoUrl ?? this.videoUrl,
      commentCount: commentCount ?? this.commentCount,
      shareCount: shareCount ?? this.shareCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      isLive: isLive ?? this.isLive,
      starCount: starCount ?? this.starCount,
    );
  }

  factory ReelsModel.fromJson(Map<String, dynamic> json) {
    return ReelsModel(
      id: json['id'] ?? 0,
      titleTm: json['title_tm'],
      titleRu: json['title_ru'],
      titleEn: json['title_en'],
      videoUrl: json['video_url'] ?? '',
      commentCount: json['comment_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      favoriteCount: json['favorite_count'] ?? 0,
      isLive: json['is_live'] == 1 || json['is_live'] == true,
      starCount: json['star_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title_tm': titleTm,
      'title_ru': titleRu,
      'title_en': titleEn,
      'video_url': videoUrl,
      'comment_count': commentCount,
      'share_count': shareCount,
      'favorite_count': favoriteCount,
      'is_live': isLive,
      'star_count': starCount,
    };
  }

  factory ReelsModel.empty() {
    return const ReelsModel(
      id: 0,
      titleTm: null,
      titleRu: null,
      titleEn: null,
      videoUrl: '',
      commentCount: 0,
      shareCount: 0,
      favoriteCount: 0,
      isLive: false,
      starCount: 0,
    );
  }

  @override
  String toString() {
    return 'ReelsModel(id: $id, videoUrl: $videoUrl)';
  }
}
