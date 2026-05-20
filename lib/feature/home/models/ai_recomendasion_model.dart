class AiRecommendationModel {
  final int id;
  final String title;
  final String? subtitle;
  final String? emoji;
  final String prompt;
  final bool isActive;
  final String? categoryId;

  AiRecommendationModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.emoji,
    required this.prompt,
    this.isActive = true,
    this.categoryId,
  });

  factory AiRecommendationModel.fromJson(Map<String, dynamic> json) {
    return AiRecommendationModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      emoji: json['image_url'] as String?,
      prompt: json['prompt'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      categoryId: json['category_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image_url': emoji,
      'prompt': prompt,
      'is_active': isActive,
      'category_id': categoryId,
    };
  }

  AiRecommendationModel copyWith({
    int? id,
    String? title,
    String? subtitle,
    String? emoji,
    String? prompt,
    bool? isActive,
    String? categoryId,
  }) {
    return AiRecommendationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      emoji: emoji ?? this.emoji,
      prompt: prompt ?? this.prompt,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
