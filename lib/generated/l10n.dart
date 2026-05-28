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

  /// `Hawa`
  String get yes {
    return Intl.message(
      'Hawa',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Ýok`
  String get no {
    return Intl.message(
      'Ýok',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Goşmak`
  String get add {
    return Intl.message(
      'Goşmak',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Maglumat ýok`
  String get noDataAvailable {
    return Intl.message(
      'Maglumat ýok',
      name: 'noDataAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Kamera`
  String get camera {
    return Intl.message(
      'Kamera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallereýa`
  String get gallery {
    return Intl.message(
      'Gallereýa',
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

  /// `Habarlar`
  String get chats {
    return Intl.message(
      'Habarlar',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Sebet`
  String get card {
    return Intl.message(
      'Sebet',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `Meniň Mbium`
  String get my_mbium {
    return Intl.message(
      'Meniň Mbium',
      name: 'my_mbium',
      desc: '',
      args: [],
    );
  }

  /// `Harytlar`
  String get products {
    return Intl.message(
      'Harytlar',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `Öndürijiler`
  String get ondurijiler {
    return Intl.message(
      'Öndürijiler',
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

  /// `Derejäni galdyr`
  String get derejani_galdyr {
    return Intl.message(
      'Derejäni galdyr',
      name: 'derejani_galdyr',
      desc: '',
      args: [],
    );
  }

  /// `Täzele`
  String get refresh {
    return Intl.message(
      'Täzele',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `Näsazlyk ýüze çykdy`
  String get nasazlyk_yuze_cykdy {
    return Intl.message(
      'Näsazlyk ýüze çykdy',
      name: 'nasazlyk_yuze_cykdy',
      desc: '',
      args: [],
    );
  }

  /// `Kategoriýalar`
  String get categories {
    return Intl.message(
      'Kategoriýalar',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Kategoriýa`
  String get category {
    return Intl.message(
      'Kategoriýa',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `boýunça`
  String get boyunca {
    return Intl.message(
      'boýunça',
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

  /// `satyş`
  String get satys {
    return Intl.message(
      'satyş',
      name: 'satys',
      desc: '',
      args: [],
    );
  }

  /// `Gözleg...`
  String get search {
    return Intl.message(
      'Gözleg...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Içki kategoriýa ýok`
  String get category_empty {
    return Intl.message(
      'Içki kategoriýa ýok',
      name: 'category_empty',
      desc: '',
      args: [],
    );
  }

  /// `AI Agendyň`
  String get ai_agendyn {
    return Intl.message(
      'AI Agendyň',
      name: 'ai_agendyn',
      desc: '',
      args: [],
    );
  }

  /// `maslahat berýän harytlary`
  String get maslahat_beryan_harytlary {
    return Intl.message(
      'maslahat berýän harytlary',
      name: 'maslahat_beryan_harytlary',
      desc: '',
      args: [],
    );
  }

  /// `Türkmenistanyň ähli ýerinden öýden çykman söwda ediň`
  String get turkmenistanda_oyden_cykman_sowda_et {
    return Intl.message(
      'Türkmenistanyň ähli ýerinden öýden çykman söwda ediň',
      name: 'turkmenistanda_oyden_cykman_sowda_et',
      desc: '',
      args: [],
    );
  }

  /// `Sargyt goraglylygy we \n uly arzanladyşlar`
  String get sargyt_goraglylygy {
    return Intl.message(
      'Sargyt goraglylygy we \n uly arzanladyşlar',
      name: 'sargyt_goraglylygy',
      desc: '',
      args: [],
    );
  }

  /// `Google bilen dowam et`
  String get google_dowan_et {
    return Intl.message(
      'Google bilen dowam et',
      name: 'google_dowan_et',
      desc: '',
      args: [],
    );
  }

  /// `Telefon belgi arkaly dowam et`
  String get telefon_bilen_dowam_et {
    return Intl.message(
      'Telefon belgi arkaly dowam et',
      name: 'telefon_bilen_dowam_et',
      desc: '',
      args: [],
    );
  }

  /// `Elektron poçta arkaly dowam et`
  String get email_bilen_dowam_et {
    return Intl.message(
      'Elektron poçta arkaly dowam et',
      name: 'email_bilen_dowam_et',
      desc: '',
      args: [],
    );
  }

  /// `Myhman hökmünde dowam et`
  String get myhma_hokmunde {
    return Intl.message(
      'Myhman hökmünde dowam et',
      name: 'myhma_hokmunde',
      desc: '',
      args: [],
    );
  }

  /// `Myhman`
  String get myhman {
    return Intl.message(
      'Myhman',
      name: 'myhman',
      desc: '',
      args: [],
    );
  }

  /// `Ulgama girmeklik üçin basyň`
  String get myhman_desc {
    return Intl.message(
      'Ulgama girmeklik üçin basyň',
      name: 'myhman_desc',
      desc: '',
      args: [],
    );
  }

  /// `Aýratynlyklar`
  String get ayratynlyklar {
    return Intl.message(
      'Aýratynlyklar',
      name: 'ayratynlyklar',
      desc: '',
      args: [],
    );
  }

  /// `Halanlarym`
  String get favorites {
    return Intl.message(
      'Halanlarym',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Taryhy`
  String get history {
    return Intl.message(
      'Taryhy',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Abuna`
  String get abuna {
    return Intl.message(
      'Abuna',
      name: 'abuna',
      desc: '',
      args: [],
    );
  }

  /// `Kuponlar`
  String get kupons {
    return Intl.message(
      'Kuponlar',
      name: 'kupons',
      desc: '',
      args: [],
    );
  }

  /// `Tölegler`
  String get tolegler {
    return Intl.message(
      'Tölegler',
      name: 'tolegler',
      desc: '',
      args: [],
    );
  }

  /// `AI agendi mugt barlap göriň we has doly maglumat almak üçin agza boluň`
  String get ai_agent_mugt_barla_desc {
    return Intl.message(
      'AI agendi mugt barlap göriň we has doly maglumat almak üçin agza boluň',
      name: 'ai_agent_mugt_barla_desc',
      desc: '',
      args: [],
    );
  }

  /// `Meniň sargytlarym`
  String get menin_sargytlarym {
    return Intl.message(
      'Meniň sargytlarym',
      name: 'menin_sargytlarym',
      desc: '',
      args: [],
    );
  }

  /// `AI agendiň MUGT döwri`
  String get ai_agendin_mugt_dowri {
    return Intl.message(
      'AI agendiň MUGT döwri',
      name: 'ai_agendin_mugt_dowri',
      desc: '',
      args: [],
    );
  }

  /// `MBIUM-da satyp başla`
  String get mbiumda_satyp_basla {
    return Intl.message(
      'MBIUM-da satyp başla',
      name: 'mbiumda_satyp_basla',
      desc: '',
      args: [],
    );
  }

  /// `Ählisi`
  String get ahlisi {
    return Intl.message(
      'Ählisi',
      name: 'ahlisi',
      desc: '',
      args: [],
    );
  }

  /// `Aýakgaplar`
  String get ayakgaplar {
    return Intl.message(
      'Aýakgaplar',
      name: 'ayakgaplar',
      desc: '',
      args: [],
    );
  }

  /// `Egin-eşikler`
  String get egin_esikler {
    return Intl.message(
      'Egin-eşikler',
      name: 'egin_esikler',
      desc: '',
      args: [],
    );
  }

  /// `Elektronika`
  String get elektronika {
    return Intl.message(
      'Elektronika',
      name: 'elektronika',
      desc: '',
      args: [],
    );
  }

  /// `Oýnawaçlar`
  String get oyuncaklar {
    return Intl.message(
      'Oýnawaçlar',
      name: 'oyuncaklar',
      desc: '',
      args: [],
    );
  }

  /// `Kitaplar`
  String get kitaplar {
    return Intl.message(
      'Kitaplar',
      name: 'kitaplar',
      desc: '',
      args: [],
    );
  }

  /// `Mugt dastawka`
  String get mugt_dastawka {
    return Intl.message(
      'Mugt dastawka',
      name: 'mugt_dastawka',
      desc: '',
      args: [],
    );
  }

  /// `MBIUM Coin bilen töleseňiz`
  String get mbium_coin_bilen {
    return Intl.message(
      'MBIUM Coin bilen töleseňiz',
      name: 'mbium_coin_bilen',
      desc: '',
      args: [],
    );
  }

  /// `Baha goraglylygy`
  String get baha_goraglylygy {
    return Intl.message(
      'Baha goraglylygy',
      name: 'baha_goraglylygy',
      desc: '',
      args: [],
    );
  }

  /// `60 güne çenli`
  String get gune_cenli {
    return Intl.message(
      '60 güne çenli',
      name: 'gune_cenli',
      desc: '',
      args: [],
    );
  }

  /// `Mugt dastawka MBIUM Coin bilen töleseňiz`
  String get mugt_dastawka_mbium_coin {
    return Intl.message(
      'Mugt dastawka MBIUM Coin bilen töleseňiz',
      name: 'mugt_dastawka_mbium_coin',
      desc: '',
      args: [],
    );
  }

  /// `Maslahat beriýänler`
  String get maslahat_beriyanler {
    return Intl.message(
      'Maslahat beriýänler',
      name: 'maslahat_beriyanler',
      desc: '',
      args: [],
    );
  }

  /// `Saýlanan geýimlere görä harytlarymyz`
  String get maslahat_beriyanler_subtitle {
    return Intl.message(
      'Saýlanan geýimlere görä harytlarymyz',
      name: 'maslahat_beriyanler_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Sargytlar`
  String get sargytlar {
    return Intl.message(
      'Sargytlar',
      name: 'sargytlar',
      desc: '',
      args: [],
    );
  }

  /// `Duýduryş`
  String get duydurys {
    return Intl.message(
      'Duýduryş',
      name: 'duydurys',
      desc: '',
      args: [],
    );
  }

  /// `Başga`
  String get basga {
    return Intl.message(
      'Başga',
      name: 'basga',
      desc: '',
      args: [],
    );
  }

  /// `Habarlary ýa-da üpjünçileri gözle`
  String get habarlary_gozle {
    return Intl.message(
      'Habarlary ýa-da üpjünçileri gözle',
      name: 'habarlary_gozle',
      desc: '',
      args: [],
    );
  }

  /// `Okalmanlar`
  String get okalmanlar {
    return Intl.message(
      'Okalmanlar',
      name: 'okalmanlar',
      desc: '',
      args: [],
    );
  }

  /// `Meniň belgim`
  String get menin_belgim {
    return Intl.message(
      'Meniň belgim',
      name: 'menin_belgim',
      desc: '',
      args: [],
    );
  }

  /// `Habar ýok`
  String get habar_yok {
    return Intl.message(
      'Habar ýok',
      name: 'habar_yok',
      desc: '',
      args: [],
    );
  }

  /// `Sargyt goragyny almak üçin diňe MBIUM-da gürleşiň we geleşik ediň.`
  String get sargyt_goragy_text {
    return Intl.message(
      'Sargyt goragyny almak üçin diňe MBIUM-da gürleşiň we geleşik ediň.',
      name: 'sargyt_goragy_text',
      desc: '',
      args: [],
    );
  }

  /// `Has giňişleýin`
  String get has_ginisleyin {
    return Intl.message(
      'Has giňişleýin',
      name: 'has_ginisleyin',
      desc: '',
      args: [],
    );
  }

  /// `Siz üçin maslahat beriýär`
  String get siz_ucin_maslahat {
    return Intl.message(
      'Siz üçin maslahat beriýär',
      name: 'siz_ucin_maslahat',
      desc: '',
      args: [],
    );
  }

  /// `Möhüm habarlary sypdyrmazlyk üçin duýduryşy açyň`
  String get mohum_habarlary {
    return Intl.message(
      'Möhüm habarlary sypdyrmazlyk üçin duýduryşy açyň',
      name: 'mohum_habarlary',
      desc: '',
      args: [],
    );
  }

  /// `Sebet`
  String get sebet {
    return Intl.message(
      'Sebet',
      name: 'sebet',
      desc: '',
      args: [],
    );
  }

  /// `Sebediniz boş`
  String get sebedinez_bos {
    return Intl.message(
      'Sebediniz boş',
      name: 'sebedinez_bos',
      desc: '',
      args: [],
    );
  }

  /// `MUGT ELTIP BERMEK maks`
  String get mugt_eltip_bermek_maks {
    return Intl.message(
      'MUGT ELTIP BERMEK maks',
      name: 'mugt_eltip_bermek_maks',
      desc: '',
      args: [],
    );
  }

  /// `Satyn al`
  String get satyn_al {
    return Intl.message(
      'Satyn al',
      name: 'satyn_al',
      desc: '',
      args: [],
    );
  }

  /// `US-a eltip bermek`
  String get us_a_eltip_bermek {
    return Intl.message(
      'US-a eltip bermek',
      name: 'us_a_eltip_bermek',
      desc: '',
      args: [],
    );
  }

  /// `Mbium.com sargyt goragy`
  String get alibaba_sargyt_goragy {
    return Intl.message(
      'Mbium.com sargyt goragy',
      name: 'alibaba_sargyt_goragy',
      desc: '',
      args: [],
    );
  }

  /// `Diňe Mbium.com arkaly ýerleşdirilen we tölenen sargytlar mugt goragdan peýdalanyp biler 🛡️ Trade Assurance`
  String get alibaba_sargyt_goragy_desc {
    return Intl.message(
      'Diňe Mbium.com arkaly ýerleşdirilen we tölenen sargytlar mugt goragdan peýdalanyp biler 🛡️ Trade Assurance',
      name: 'alibaba_sargyt_goragy_desc',
      desc: '',
      args: [],
    );
  }

  /// `Ynamly\ntölegler`
  String get ynamly_tolegier {
    return Intl.message(
      'Ynamly\ntölegler',
      name: 'ynamly_tolegier',
      desc: '',
      args: [],
    );
  }

  /// `Kepillendirilen\neltip bermek`
  String get kepillendirilen_eltip_bermek {
    return Intl.message(
      'Kepillendirilen\neltip bermek',
      name: 'kepillendirilen_eltip_bermek',
      desc: '',
      args: [],
    );
  }

  /// `Yza\ngaytarmak\ngoragy`
  String get yza_gaytarmak_goragy {
    return Intl.message(
      'Yza\ngaytarmak\ngoragy',
      name: 'yza_gaytarmak_goragy',
      desc: '',
      args: [],
    );
  }

  /// `Goldanylýan töleg usullary`
  String get goldanylyan_toleg_usullary {
    return Intl.message(
      'Goldanylýan töleg usullary',
      name: 'goldanylyan_toleg_usullary',
      desc: '',
      args: [],
    );
  }

  /// `Haryt ýok`
  String get product_empty {
    return Intl.message(
      'Haryt ýok',
      name: 'product_empty',
      desc: '',
      args: [],
    );
  }

  /// `Siziň üçin`
  String get sizin_ucin {
    return Intl.message(
      'Siziň üçin',
      name: 'sizin_ucin',
      desc: '',
      args: [],
    );
  }

String get mbium_sargyt_goraglylygy {
  return Intl.message(
    'MBIUM sargyt goraglylygy',
    name: 'mbium_sargyt_goraglylygy',
    desc: '',
    args: [],
  );
}

String get mbium_sargyt_goraglylygy_desc {
  return Intl.message(
    'Diňe MBIUM bonuslaryň üsti bilen tölenen we ýerleşdirilen harytlar Mugt goragdan peýdalanyp biliner',
    name: 'mbium_sargyt_goraglylygy_desc',
    desc: '',
    args: [],
  );
}

String get toleg_usullary {
  return Intl.message(
    'Töleg usullary:',
    name: 'toleg_usullary',
    desc: '',
    args: [],
  );
}

String get turkmenistanda_in_gowysy {
  return Intl.message(
    'Türkmenistanda iň gowysy',
    name: 'turkmenistanda_in_gowysy',
    desc: '',
    args: [],
  );
}

String get kategoriyany_saylan {
  return Intl.message(
    'Kategoriýany saýlaň',
    name: 'kategoriyany_saylan',
    desc: '',
    args: [],
  );
}

String get satuw_liderleri {
  return Intl.message(
    'Satuw liderleri',
    name: 'satuw_liderleri',
    desc: '',
    args: [],
  );
}

String get in_meshgurlar {
  return Intl.message(
    'Iň meşgurlar',
    name: 'in_meshgurlar',
    desc: '',
    args: [],
  );
}

String get oz_bahany_sayla {
  return Intl.message(
    'Öz bahaňy saýla',
    name: 'oz_bahany_sayla',
    desc: '',
    args: [],
  );
}

String get obrazesleri_al {
  return Intl.message(
    'Obrazesleri al',
    name: 'obrazesleri_al',
    desc: '',
    args: [],
  );
}

String get ondabaryjy_ondurijiler {
  return Intl.message(
    'Öndabaryjy öndürijiler',
    name: 'ondabaryjy_ondurijiler',
    desc: '',
    args: [],
  );
}

String get obrazesler_boyunca_tayyarlanan {
  return Intl.message(
    'Obrazesler boýunça tayyarlanan',
    name: 'obrazesler_boyunca_tayyarlanan',
    desc: '',
    args: [],
  );
}

String get dalandyrys_sertifikaty_bolan {
  return Intl.message(
    'Dalandyryş sertifikaty bolan',
    name: 'dalandyrys_sertifikaty_bolan',
    desc: '',
    args: [],
  );
}

String get giri_mumkin {
  return Intl.message(
    'Giriş mümkin',
    name: 'giri_mumkin',
    desc: '',
    args: [],
  );
}

String get balkan_lale_shop_name {
  return Intl.message(
    'Balkan Läle plastik önümleri HK',
    name: 'balkan_lale_shop_name',
    desc: '',
    args: [],
  );
}

String get balkan_lale_shop_desc {
  return Intl.message(
    'Sertifikatlaşdyrylan. 150 işçi+100000 zakaz ýerine ýetirilen',
    name: 'balkan_lale_shop_desc',
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
