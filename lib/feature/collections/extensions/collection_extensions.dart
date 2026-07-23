import '../data/collection_model.dart';

extension CollectionLocalization on CollectionModel {
  String collectionNameByLanguage(String langCode) {
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
