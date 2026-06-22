import 'package:intl/intl.dart';

import '../model/shop_type_model.dart';

extension ShopTypeLocalizationExtension on ShopTypeModel {
  String get localizedName {
    final currentLocale = Intl.shortLocale(Intl.getCurrentLocale());

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
}
