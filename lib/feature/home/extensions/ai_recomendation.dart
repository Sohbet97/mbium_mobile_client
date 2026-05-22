import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home/models/ai_recomendasion_model.dart';

extension PromptItemLocalization on AiRecommendationModel {
  String getTitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    switch (locale) {
      case 'tk':
        return titleTk ?? titleEn ?? '';
      case 'ru':
        return titleRu ?? titleEn ?? '';
      case 'en':
      default:
        return titleEn ?? titleTk ?? titleRu ?? '';
    }
  }

  String? getSubtitle(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    switch (locale) {
      case 'tk':
        return subtitleTk ?? subtitleEn;
      case 'ru':
        return subtitleRu ?? subtitleEn;
      case 'en':
      default:
        return subtitleEn ?? subtitleTk ?? subtitleRu;
    }
  }
}
