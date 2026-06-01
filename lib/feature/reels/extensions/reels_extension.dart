import '../models/reels_model.dart';

extension ReelsModelExtension on ReelsModel {
  String localizedTitle(String locale) {
    switch (locale) {
      case 'tm':
        return titleTm ?? '';
      case 'ru':
        return titleRu ?? '';
      case 'en':
        return titleEn ?? '';
      default:
        return titleEn ?? '';
    }
  }
}
