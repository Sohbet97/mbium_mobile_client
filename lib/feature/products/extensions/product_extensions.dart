import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

enum AppLanguage {
  tk,
  ru,
  en;

  static AppLanguage fromCode(String code) => switch (code) {
        'ru' => AppLanguage.ru,
        'en' => AppLanguage.en,
        _ => AppLanguage.tk,
      };
}

extension ProductLocalization on ProductModel {
  String getLocalizedName(int langIndex) {
    if (langIndex < 0 || langIndex >= AppLanguage.values.length) {
      return name;
    }

    final language = AppLanguage.values[langIndex];

    switch (language) {
      case AppLanguage.ru:
        return nameRu.isNotEmpty ? nameRu : name;
      case AppLanguage.en:
        return nameEng.isNotEmpty ? nameEng : name;
      default:
        return name;
    }
  }

  String nameByLang(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.ru:
        return nameRu.isNotEmpty ? nameRu : name;
      case AppLanguage.en:
        return nameEng.isNotEmpty ? nameEng : name;
      case AppLanguage.tk:
        return name;
    }
  }
}

extension ProductDetailLocalization on ProductDetailModel {
  String nameByLang(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.ru:
        return nameRu.isNotEmpty ? nameRu : name;
      case AppLanguage.en:
        return nameEng.isNotEmpty ? nameEng : name;
      case AppLanguage.tk:
        return name;
    }
  }

  /// API пока возвращает одно поле description без локализации
  String descriptionByLang(AppLanguage lang) => description;
}
