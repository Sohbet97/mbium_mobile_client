class AiRecommendationModel {
  final int? id;
  final String? titleTk;
  final String? titleRu;
  final String? titleEn;
  final String? subtitleTk;
  final String? subtitleRu;
  final String? subtitleEn;
  final String? emoji;
  final String? prompt;
  final int? sortOrder;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AiRecommendationModel({
    this.id,
    this.titleTk,
    this.titleRu,
    this.titleEn,
    this.subtitleTk,
    this.subtitleRu,
    this.subtitleEn,
    this.emoji,
    this.prompt,
    this.sortOrder,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory AiRecommendationModel.fromJson(Map<String, dynamic> json) =>
      AiRecommendationModel(
        id: json["id"],
        titleTk: json["title_tk"],
        titleRu: json["title_ru"],
        titleEn: json["title_en"],
        subtitleTk: json["subtitle_tk"],
        subtitleRu: json["subtitle_ru"],
        subtitleEn: json["subtitle_en"],
        emoji: json["emoji"],
        prompt: json["prompt"],
        sortOrder: json["sort_order"],
        isActive: json["is_active"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title_tk": titleTk,
    "title_ru": titleRu,
    "title_en": titleEn,
    "subtitle_tk": subtitleTk,
    "subtitle_ru": subtitleRu,
    "subtitle_en": subtitleEn,
    "emoji": emoji,
    "prompt": prompt,
    "sort_order": sortOrder,
    "is_active": isActive,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
