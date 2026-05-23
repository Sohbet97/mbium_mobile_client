import '../models/category_modes.dart';

extension CategoryLocalization on CategoryModel {
  String getNameByLanguage(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'ru':
        return nameRu.isNotEmpty ? nameRu : name;
      case 'en':
      case 'eng':
        return nameEng.isNotEmpty ? nameEng : name;
      default:
        return name;
    }
  }
}
