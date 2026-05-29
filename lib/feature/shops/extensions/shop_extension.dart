import 'package:intl/intl.dart';

import '../model/shop_model.dart';

extension ShopLocalizationExtension on ShopModel {
  String get localizedName {
    final currentLocale = Intl.shortLocale;

    switch (currentLocale) {
      case 'ru':
        return nameRu ?? name ?? '';
      case 'en':
        return nameEng ?? name ?? '';
      case 'tk':
      default:
        return name ?? '';
    }
  }

  String get localizedDescription {
    final currentLocale = Intl.shortLocale;

    switch (currentLocale) {
      case 'ru':
        return descriptionRu ?? description ?? '';
      case 'en':
        return descriptionEn ?? description ?? '';
      case 'tk':
      default:
        return descriptionTm ?? description ?? '';
    }
  }
}
