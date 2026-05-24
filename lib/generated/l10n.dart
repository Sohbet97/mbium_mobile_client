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

  /// `By region`
  String get welayatlar_boyunca {
    return Intl.message(
      'By region',
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

  /// `Sales`
  String get satys {
    return Intl.message(
      'Sales',
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

  /// `No products`
  String get product_empty {
    return Intl.message(
      'No products',
      name: 'product_empty',
      desc: '',
      args: [],
    );
  }

  /// `For you`
  String get sizin_ucin {
    return Intl.message(
      'For you',
      name: 'sizin_ucin',
      desc: '',
      args: [],
    );
  }

  /// `Shop from anywhere in Turkmenistan without leaving home`
  String get turkmenistanda_oyden_cykman_sowda_et {
    return Intl.message(
      'Shop from anywhere in Turkmenistan without leaving home',
      name: 'turkmenistanda_oyden_cykman_sowda_et',
      desc: '',
      args: [],
    );
  }

  /// `Order protection and \n big discounts`
  String get sargyt_goraglylygy {
    return Intl.message(
      'Order protection and \n big discounts',
      name: 'sargyt_goraglylygy',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get google_dowan_et {
    return Intl.message(
      'Continue with Google',
      name: 'google_dowan_et',
      desc: '',
      args: [],
    );
  }

  /// `Continue with phone number`
  String get telefon_bilen_dowam_et {
    return Intl.message(
      'Continue with phone number',
      name: 'telefon_bilen_dowam_et',
      desc: '',
      args: [],
    );
  }

  /// `Continue with email`
  String get email_bilen_dowam_et {
    return Intl.message(
      'Continue with email',
      name: 'email_bilen_dowam_et',
      desc: '',
      args: [],
    );
  }

  /// `Continue as guest`
  String get myhma_hokmunde {
    return Intl.message(
      'Continue as guest',
      name: 'myhma_hokmunde',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get myhman {
    return Intl.message(
      'Guest',
      name: 'myhman',
      desc: '',
      args: [],
    );
  }

  /// `Tap to sign in`
  String get myhman_desc {
    return Intl.message(
      'Tap to sign in',
      name: 'myhman_desc',
      desc: '',
      args: [],
    );
  }

  /// `Features`
  String get ayratynlyklar {
    return Intl.message(
      'Features',
      name: 'ayratynlyklar',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get abuna {
    return Intl.message(
      'Subscription',
      name: 'abuna',
      desc: '',
      args: [],
    );
  }

  /// `Coupons`
  String get kupons {
    return Intl.message(
      'Coupons',
      name: 'kupons',
      desc: '',
      args: [],
    );
  }

  /// `Payments`
  String get tolegler {
    return Intl.message(
      'Payments',
      name: 'tolegler',
      desc: '',
      args: [],
    );
  }

  /// `Try the AI agent for free and subscribe for full access`
  String get ai_agent_mugt_barla_desc {
    return Intl.message(
      'Try the AI agent for free and subscribe for full access',
      name: 'ai_agent_mugt_barla_desc',
      desc: '',
      args: [],
    );
  }

  /// `My orders`
  String get menin_sargytlarym {
    return Intl.message(
      'My orders',
      name: 'menin_sargytlarym',
      desc: '',
      args: [],
    );
  }

  /// `AI agent FREE period`
  String get ai_agendin_mugt_dowri {
    return Intl.message(
      'AI agent FREE period',
      name: 'ai_agendin_mugt_dowri',
      desc: '',
      args: [],
    );
  }

  /// `Start selling on MBIUM`
  String get mbiumda_satyp_basla {
    return Intl.message(
      'Start selling on MBIUM',
      name: 'mbiumda_satyp_basla',
      desc: '',
      args: [],
    );
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
