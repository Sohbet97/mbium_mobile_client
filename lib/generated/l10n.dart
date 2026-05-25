// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mbium`
  String get AppName {
    return Intl.message(
      'Mbium',
      name: 'AppName',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noDataAvailable {
    return Intl.message(
      'No data available',
      name: 'noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Reels`
  String get reels {
    return Intl.message(
      'Reels',
      name: 'reels',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get card {
    return Intl.message(
      'Cart',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `My Mbium`
  String get my_mbium {
    return Intl.message(
      'My Mbium',
      name: 'my_mbium',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Shops`
  String get ondurijiler {
    return Intl.message(
      'Shops',
      name: 'ondurijiler',
      desc: '',
      args: [],
    );
  }

  /// `Welaýatlar boýunça`
  String get welayatlar_boyunca {
    return Intl.message(
      'Welaýatlar boýunça',
      name: 'welayatlar_boyunca',
      desc: '',
      args: [],
    );
  }

  /// `AI agent`
  String get Ai_agent {
    return Intl.message(
      'AI agent',
      name: 'Ai_agent',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get nasazlyk_yuze_cykdy {
    return Intl.message(
      'An error occurred',
      name: 'nasazlyk_yuze_cykdy',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade level`
  String get derejani_galdyr {
    return Intl.message(
      'Upgrade level',
      name: 'derejani_galdyr',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `by`
  String get boyunca {
    return Intl.message(
      'by',
      name: 'boyunca',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get top {
    return Intl.message(
      'Top',
      name: 'top',
      desc: '',
      args: [],
    );
  }

  /// `Live`
  String get live {
    return Intl.message(
      'Live',
      name: 'live',
      desc: '',
      args: [],
    );
  }

  /// `sales`
  String get satys {
    return Intl.message(
      'sales',
      name: 'satys',
      desc: '',
      args: [],
    );
  }

  /// `Search...`
  String get search {
    return Intl.message(
      'Search...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `No subcategory`
  String get category_empty {
    return Intl.message(
      'No subcategory',
      name: 'category_empty',
      desc: '',
      args: [],
    );
  }

  /// `AI Agent's`
  String get ai_agendyn {
    return Intl.message(
      'AI Agent\'s',
      name: 'ai_agendyn',
      desc: '',
      args: [],
    );
  }

  /// `recommended products`
  String get maslahat_beryan_harytlary {
    return Intl.message(
      'recommended products',
      name: 'maslahat_beryan_harytlary',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get ahlisi {
    return Intl.message(
      'All',
      name: 'ahlisi',
      desc: '',
      args: [],
    );
  }

  /// `Footwear`
  String get ayakgaplar {
    return Intl.message(
      'Footwear',
      name: 'ayakgaplar',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get egin_esikler {
    return Intl.message(
      'Clothing',
      name: 'egin_esikler',
      desc: '',
      args: [],
    );
  }

  /// `Electronics`
  String get elektronika {
    return Intl.message(
      'Electronics',
      name: 'elektronika',
      desc: '',
      args: [],
    );
  }

  /// `Toys`
  String get oyuncaklar {
    return Intl.message(
      'Toys',
      name: 'oyuncaklar',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get kitaplar {
    return Intl.message(
      'Books',
      name: 'kitaplar',
      desc: '',
      args: [],
    );
  }

  /// `Free delivery`
  String get mugt_dastawka {
    return Intl.message(
      'Free delivery',
      name: 'mugt_dastawka',
      desc: '',
      args: [],
    );
  }

  /// `Pay with MBIUM Coin`
  String get mbium_coin_bilen {
    return Intl.message(
      'Pay with MBIUM Coin',
      name: 'mbium_coin_bilen',
      desc: '',
      args: [],
    );
  }

  /// `Price protection`
  String get baha_goraglylygy {
    return Intl.message(
      'Price protection',
      name: 'baha_goraglylygy',
      desc: '',
      args: [],
    );
  }

  /// `Up to 60 days`
  String get gune_cenli {
    return Intl.message(
      'Up to 60 days',
      name: 'gune_cenli',
      desc: '',
      args: [],
    );
  }

  /// `Free delivery when paying with MBIUM Coin`
  String get mugt_dastawka_mbium_coin {
    return Intl.message(
      'Free delivery when paying with MBIUM Coin',
      name: 'mugt_dastawka_mbium_coin',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get maslahat_beriyanler {
    return Intl.message(
      'Recommended',
      name: 'maslahat_beriyanler',
      desc: '',
      args: [],
    );
  }

  /// `Products based on your selected clothing`
  String get maslahat_beriyanler_subtitle {
    return Intl.message(
      'Products based on your selected clothing',
      name: 'maslahat_beriyanler_subtitle',
      desc: '',
      args: [],
    );
  }
  String get sargytlar {
    return Intl.message('Sargytlar', name: 'sargytlar', args: []);
  }

  String get duydurys {
    return Intl.message('Duýduryş', name: 'duydurys', args: []);
  }

  String get basga {
    return Intl.message('Başga', name: 'basga', args: []);
  }

  String get habarlary_gozle {
    return Intl.message('Habarlary ýa-da üpjünçileri gözle', name: 'habarlary_gozle', args: []);
  }

  String get okalmanlar {
    return Intl.message('Okalmanlar', name: 'okalmanlar', args: []);
  }

  String get menin_belgim {
    return Intl.message('Meniň belgim', name: 'menin_belgim', args: []);
  }

  String get habar_yok {
    return Intl.message('Habar ýok', name: 'habar_yok', args: []);
  }

  String get sargyt_goragy_text {
    return Intl.message('Sargyt goragyny almak üçin diňe MBIUM-da gürleşiň we geleşik ediň.', name: 'sargyt_goragy_text', args: []);
  }

  String get has_ginisleyin {
    return Intl.message('Has giňişleýin', name: 'has_ginisleyin', args: []);
  }

  String get siz_ucin_maslahat {
    return Intl.message('Siz üçin maslahat beriýär', name: 'siz_ucin_maslahat', args: []);
  }
 
  String get mohum_habarlary {
  return Intl.message('Möhüm habarlary sypdyrmazlyk üçin duýduryşy açyň', name: 'mohum_habarlary', args: []);
}
}


class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'tk'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
