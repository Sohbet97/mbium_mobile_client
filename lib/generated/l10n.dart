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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mbium`
  String get AppName {
    return Intl.message('Mbium', name: 'AppName', desc: '', args: []);
  }

  /// `Hawa`
  String get yes {
    return Intl.message('Hawa', name: 'yes', desc: '', args: []);
  }

  /// `Ýok`
  String get no {
    return Intl.message('Ýok', name: 'no', desc: '', args: []);
  }

  /// `Goşmak`
  String get add {
    return Intl.message('Goşmak', name: 'add', desc: '', args: []);
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
    return Intl.message('Kamera', name: 'camera', desc: '', args: []);
  }

  /// `Gallereýa`
  String get gallery {
    return Intl.message('Gallereýa', name: 'gallery', desc: '', args: []);
  }

  /// `Reels`
  String get reels {
    return Intl.message('Reels', name: 'reels', desc: '', args: []);
  }

  /// `Habarlar`
  String get chats {
    return Intl.message('Habarlar', name: 'chats', desc: '', args: []);
  }

  /// `Sebet`
  String get card {
    return Intl.message('Sebet', name: 'card', desc: '', args: []);
  }

  /// `Meniň Mbium`
  String get my_mbium {
    return Intl.message('Meniň Mbium', name: 'my_mbium', desc: '', args: []);
  }

  /// `Harytlar`
  String get products {
    return Intl.message('Harytlar', name: 'products', desc: '', args: []);
  }

  /// `Öndürijiler`
  String get ondurijiler {
    return Intl.message('Öndürijiler', name: 'ondurijiler', desc: '', args: []);
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
    return Intl.message('AI agent', name: 'Ai_agent', desc: '', args: []);
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
    return Intl.message('Täzele', name: 'refresh', desc: '', args: []);
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
    return Intl.message('Kategoriýa', name: 'category', desc: '', args: []);
  }

  /// `boýunça`
  String get boyunca {
    return Intl.message('boýunça', name: 'boyunca', desc: '', args: []);
  }

  /// `Top`
  String get top {
    return Intl.message('Top', name: 'top', desc: '', args: []);
  }

  /// `Live`
  String get live {
    return Intl.message('Live', name: 'live', desc: '', args: []);
  }

  /// `satyş`
  String get satys {
    return Intl.message('satyş', name: 'satys', desc: '', args: []);
  }

  /// `Gözleg...`
  String get search {
    return Intl.message('Gözleg...', name: 'search', desc: '', args: []);
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
    return Intl.message('AI Agendyň', name: 'ai_agendyn', desc: '', args: []);
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
    return Intl.message('Myhman', name: 'myhman', desc: '', args: []);
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
    return Intl.message('Halanlarym', name: 'favorites', desc: '', args: []);
  }

  /// `Taryhy`
  String get history {
    return Intl.message('Taryhy', name: 'history', desc: '', args: []);
  }

  /// `Abuna`
  String get abuna {
    return Intl.message('Abuna', name: 'abuna', desc: '', args: []);
  }

  /// `Kuponlar`
  String get kupons {
    return Intl.message('Kuponlar', name: 'kupons', desc: '', args: []);
  }

  /// `Tölegler`
  String get tolegler {
    return Intl.message('Tölegler', name: 'tolegler', desc: '', args: []);
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
    return Intl.message('Ählisi', name: 'ahlisi', desc: '', args: []);
  }

  /// `Aýakgaplar`
  String get ayakgaplar {
    return Intl.message('Aýakgaplar', name: 'ayakgaplar', desc: '', args: []);
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
    return Intl.message('Elektronika', name: 'elektronika', desc: '', args: []);
  }

  /// `Oýnawaçlar`
  String get oyuncaklar {
    return Intl.message('Oýnawaçlar', name: 'oyuncaklar', desc: '', args: []);
  }

  /// `Kitaplar`
  String get kitaplar {
    return Intl.message('Kitaplar', name: 'kitaplar', desc: '', args: []);
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
    return Intl.message('Sargytlar', name: 'sargytlar', desc: '', args: []);
  }

  /// `Duýduryş`
  String get duydurys {
    return Intl.message('Duýduryş', name: 'duydurys', desc: '', args: []);
  }

  /// `Başga`
  String get basga {
    return Intl.message('Başga', name: 'basga', desc: '', args: []);
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
    return Intl.message('Okalmanlar', name: 'okalmanlar', desc: '', args: []);
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
    return Intl.message('Habar ýok', name: 'habar_yok', desc: '', args: []);
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
    return Intl.message('Sebet', name: 'sebet', desc: '', args: []);
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
    return Intl.message('Satyn al', name: 'satyn_al', desc: '', args: []);
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

  /// `MBIUM sargyt goraglylygy`
  String get alibaba_sargyt_goragy {
    return Intl.message(
      'MBIUM sargyt goraglylygy',
      name: 'alibaba_sargyt_goragy',
      desc: '',
      args: [],
    );
  }

  /// `Diňe MBIUM bonuslaryň üsti bilen tölenen we ýerleşdirilen harytlar Mugt goragdan peýdalanyp biliner`
  String get alibaba_sargyt_goragy_desc {
    return Intl.message(
      'Diňe MBIUM bonuslaryň üsti bilen tölenen we ýerleşdirilen harytlar Mugt goragdan peýdalanyp biliner',
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
    return Intl.message('Haryt ýok', name: 'product_empty', desc: '', args: []);
  }

  /// `Siziň üçin`
  String get sizin_ucin {
    return Intl.message('Siziň üçin', name: 'sizin_ucin', desc: '', args: []);
  }

  /// `Töleg usullary:`
  String get toleg_usullary {
    return Intl.message(
      'Töleg usullary:',
      name: 'toleg_usullary',
      desc: '',
      args: [],
    );
  }

  /// `Türkmenistanda iň gowysy`
  String get turkmenistanda_in_gowysy {
    return Intl.message(
      'Türkmenistanda iň gowysy',
      name: 'turkmenistanda_in_gowysy',
      desc: '',
      args: [],
    );
  }

  /// `Kategoriýany saýlaň`
  String get kategoriyany_saylan {
    return Intl.message(
      'Kategoriýany saýlaň',
      name: 'kategoriyany_saylan',
      desc: '',
      args: [],
    );
  }

  /// `Satuw liderleri`
  String get satuw_liderleri {
    return Intl.message(
      'Satuw liderleri',
      name: 'satuw_liderleri',
      desc: '',
      args: [],
    );
  }

  /// `Iň meşgurlar`
  String get in_meshgurlar {
    return Intl.message(
      'Iň meşgurlar',
      name: 'in_meshgurlar',
      desc: '',
      args: [],
    );
  }

  /// `Öz bahaňy saýla`
  String get oz_bahany_sayla {
    return Intl.message(
      'Öz bahaňy saýla',
      name: 'oz_bahany_sayla',
      desc: '',
      args: [],
    );
  }

  /// `Obrazesleri al`
  String get obrazesleri_al {
    return Intl.message(
      'Obrazesleri al',
      name: 'obrazesleri_al',
      desc: '',
      args: [],
    );
  }

  /// `Öndabaryjy öndürijiler`
  String get ondabaryjy_ondurijiler {
    return Intl.message(
      'Öndabaryjy öndürijiler',
      name: 'ondabaryjy_ondurijiler',
      desc: '',
      args: [],
    );
  }

  /// `Obrazesler boýunça taýýarlanan`
  String get obrazesler_boyunca_tayyarlanan {
    return Intl.message(
      'Obrazesler boýunça taýýarlanan',
      name: 'obrazesler_boyunca_tayyarlanan',
      desc: '',
      args: [],
    );
  }

  /// `Dalandyryş sertifikaty bolan`
  String get dalandyrys_sertifikaty_bolan {
    return Intl.message(
      'Dalandyryş sertifikaty bolan',
      name: 'dalandyrys_sertifikaty_bolan',
      desc: '',
      args: [],
    );
  }

  /// `Giriş mümkin`
  String get giri_mumkin {
    return Intl.message(
      'Giriş mümkin',
      name: 'giri_mumkin',
      desc: '',
      args: [],
    );
  }

  /// `Balkan Läle plastik önümleri HK`
  String get balkan_lale_shop_name {
    return Intl.message(
      'Balkan Läle plastik önümleri HK',
      name: 'balkan_lale_shop_name',
      desc: '',
      args: [],
    );
  }

  /// `Sertifikatlaşdyrylan. 150 işçi+100000 zakaz ýerine ýetirilen`
  String get balkan_lale_shop_desc {
    return Intl.message(
      'Sertifikatlaşdyrylan. 150 işçi+100000 zakaz ýerine ýetirilen',
      name: 'balkan_lale_shop_desc',
      desc: '',
      args: [],
    );
  }

  /// `MBIUM satyş bilen Türkmenistan boýunça biznes syýahatyňyza başlaň`
  String get mbium_satys_bilen_biznes {
    return Intl.message(
      'MBIUM satyş bilen Türkmenistan boýunça biznes syýahatyňyza başlaň',
      name: 'mbium_satys_bilen_biznes',
      desc: '',
      args: [],
    );
  }

  /// `Tutuş ýurt boýunça müňlerçe alyjylar`
  String get tutus_yurt_boyunca_alyjylar {
    return Intl.message(
      'Tutuş ýurt boýunça müňlerçe alyjylar',
      name: 'tutus_yurt_boyunca_alyjylar',
      desc: '',
      args: [],
    );
  }

  /// `Çäksiz ösüş üçin`
  String get caksiz_osush_ucin {
    return Intl.message(
      'Çäksiz ösüş üçin',
      name: 'caksiz_osush_ucin',
      desc: '',
      args: [],
    );
  }

  /// `0% satuw komisiýasy`
  String get satuw_komisiyasy {
    return Intl.message(
      '0% satuw komisiýasy',
      name: 'satuw_komisiyasy',
      desc: '',
      args: [],
    );
  }

  /// `Degişli hünärmenlerden aýratyn peýdaly maslahatlar`
  String get degisli_hunarmenlerden_maslahatlar {
    return Intl.message(
      'Degişli hünärmenlerden aýratyn peýdaly maslahatlar',
      name: 'degisli_hunarmenlerden_maslahatlar',
      desc: '',
      args: [],
    );
  }

  /// `Şu gün satyjy hasabyny dörediň \nwe ýörite mümkinçilikleri açyň.`
  String get satyjy_hasabyny_doredin {
    return Intl.message(
      'Şu gün satyjy hasabyny dörediň \nwe ýörite mümkinçilikleri açyň.',
      name: 'satyjy_hasabyny_doredin',
      desc: '',
      args: [],
    );
  }

  /// `Telefon belgiňizi giriziň`
  String get telefon_belgi {
    return Intl.message(
      'Telefon belgiňizi giriziň',
      name: 'telefon_belgi',
      desc: '',
      args: [],
    );
  }

  /// `Kärhananyň ýa-da Dukanyň adyny giriziň`
  String get karhananyn_dukanyn_ady {
    return Intl.message(
      'Kärhananyň ýa-da Dukanyň adyny giriziň',
      name: 'karhananyn_dukanyn_ady',
      desc: '',
      args: [],
    );
  }

  /// `Ibermek bilen, siz MBIUM şertleri we düzgünleri \nbilen razylaşýarsyňyz`
  String get ibermek_bilen_razylasyarsynyz {
    return Intl.message(
      'Ibermek bilen, siz MBIUM şertleri we düzgünleri \nbilen razylaşýarsyňyz',
      name: 'ibermek_bilen_razylasyarsynyz',
      desc: '',
      args: [],
    );
  }

  /// `Dowam et`
  String get dowam_et {
    return Intl.message('Dowam et', name: 'dowam_et', desc: '', args: []);
  }

  /// `Sorag bar bolsa`
  String get sorag_bar_bolsa {
    return Intl.message(
      'Sorag bar bolsa',
      name: 'sorag_bar_bolsa',
      desc: '',
      args: [],
    );
  }

  /// `Göni efirdäki çada başlaň`
  String get goni_efir {
    return Intl.message(
      'Göni efirdäki çada başlaň',
      name: 'goni_efir',
      desc: '',
      args: [],
    );
  }

  /// `Profil`
  String get profil {
    return Intl.message('Profil', name: 'profil', desc: '', args: []);
  }

  /// `Habarlar`
  String get habarlar {
    return Intl.message('Habarlar', name: 'habarlar', desc: '', args: []);
  }

  /// `Dil`
  String get language {
    return Intl.message('Dil', name: 'language', desc: '', args: []);
  }

  /// `AI ýazgysy`
  String get podpiska {
    return Intl.message('AI ýazgysy', name: 'podpiska', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Русский`
  String get russkiy {
    return Intl.message('Русский', name: 'russkiy', desc: '', args: []);
  }

  /// `Türkmen`
  String get turkmence {
    return Intl.message('Türkmen', name: 'turkmence', desc: '', args: []);
  }

  /// `Salgylarym`
  String get addresses {
    return Intl.message('Salgylarym', name: 'addresses', desc: '', args: []);
  }

  /// `All Functions`
  String get all_functions {
    return Intl.message(
      'All Functions',
      name: 'all_functions',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Görülen harytlar`
  String get gorulen_harytlar {
    return Intl.message(
      'Görülen harytlar',
      name: 'gorulen_harytlar',
      desc: '',
      args: [],
    );
  }

  /// `Kuponlar`
  String get cupons {
    return Intl.message('Kuponlar', name: 'cupons', desc: '', args: []);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Ulanyş düzgünleri`
  String get ulanys_duzgunleri {
    return Intl.message(
      'Ulanyş düzgünleri',
      name: 'ulanys_duzgunleri',
      desc: '',
      args: [],
    );
  }

  /// `Sargyt etmek`
  String get sargyt_etmek {
    return Intl.message(
      'Sargyt etmek',
      name: 'sargyt_etmek',
      desc: '',
      args: [],
    );
  }

  /// `Jemi`
  String get jemi {
    return Intl.message('Jemi', name: 'jemi', desc: '', args: []);
  }

  /// `Öz bahaň we islegleriňe görä sargyt`
  String get oz_bahany_appbar_title {
    return Intl.message(
      'Öz bahaň we islegleriňe görä sargyt',
      name: 'oz_bahany_appbar_title',
      desc: '',
      args: [],
    );
  }

  /// `Soraglaryňyzy beriň we islegiňize gabat gelýän harydy tapyň`
  String get oz_bahany_sayla_title {
    return Intl.message(
      'Soraglaryňyzy beriň we islegiňize gabat gelýän harydy tapyň',
      name: 'oz_bahany_sayla_title',
      desc: '',
      args: [],
    );
  }

  /// `Müşderiňiň takyk saýlawy we bahalaryny çalt deňeşdirmesi`
  String get oz_bahany_sayla_desc {
    return Intl.message(
      'Müşderiňiň takyk saýlawy we bahalaryny çalt deňeşdirmesi',
      name: 'oz_bahany_sayla_desc',
      desc: '',
      args: [],
    );
  }

  /// `Söwda teklip sargytlarynyň iň meşgurlary`
  String get sowda_teklip_sargytlaryn_in_meshgurlary {
    return Intl.message(
      'Söwda teklip sargytlarynyň iň meşgurlary',
      name: 'sowda_teklip_sargytlaryn_in_meshgurlary',
      desc: '',
      args: [],
    );
  }

  /// `Dizaýn sazlamalary`
  String get dizayn_sazlamalary {
    return Intl.message(
      'Dizaýn sazlamalary',
      name: 'dizayn_sazlamalary',
      desc: '',
      args: [],
    );
  }

  /// `Logotyň görnüşi`
  String get logotypin_gornushi {
    return Intl.message(
      'Logotyň görnüşi',
      name: 'logotypin_gornushi',
      desc: '',
      args: [],
    );
  }

  /// `Toplumyň sazlamalary`
  String get toplumyn_sazlamalary {
    return Intl.message(
      'Toplumyň sazlamalary',
      name: 'toplumyn_sazlamalary',
      desc: '',
      args: [],
    );
  }

  /// `ÖBS barada has giňişleýin maglumat`
  String get obs_barada_has_ginisleyin {
    return Intl.message(
      'ÖBS barada has giňişleýin maglumat',
      name: 'obs_barada_has_ginisleyin',
      desc: '',
      args: [],
    );
  }

  /// `Surat ýüklän ýa-da açar sözleri giriziň. Meselem, 100 sany oýunjak aýy, goşulan dizaýn nusgasyny görüň.`
  String get oz_bahany_surat_yuklan {
    return Intl.message(
      'Surat ýüklän ýa-da açar sözleri giriziň. Meselem, 100 sany oýunjak aýy, goşulan dizaýn nusgasyny görüň.',
      name: 'oz_bahany_surat_yuklan',
      desc: '',
      args: [],
    );
  }

  /// `Ugratmak bilen, siz MBIUM`
  String get oz_bahany_ugratmak_bilen {
    return Intl.message(
      'Ugratmak bilen, siz MBIUM',
      name: 'oz_bahany_ugratmak_bilen',
      desc: '',
      args: [],
    );
  }

  /// `hyzmat şertlerine`
  String get mbium_hyzmat_sertleri {
    return Intl.message(
      'hyzmat şertlerine',
      name: 'mbium_hyzmat_sertleri',
      desc: '',
      args: [],
    );
  }

  /// `we gizlilik syýasatyna razy bolýarsyňyz.`
  String get we_gizlilik_syyyasatyna {
    return Intl.message(
      'we gizlilik syýasatyna razy bolýarsyňyz.',
      name: 'we_gizlilik_syyyasatyna',
      desc: '',
      args: [],
    );
  }

  /// `AI kömegi bilen ÖBS-ny aňsatlyk bilen dörediň`
  String get ai_komegi_bilen_obs {
    return Intl.message(
      'AI kömegi bilen ÖBS-ny aňsatlyk bilen dörediň',
      name: 'ai_komegi_bilen_obs',
      desc: '',
      args: [],
    );
  }

  /// `Takyk islegleriňizi düzüň`
  String get takyk_isleglerini_duzun {
    return Intl.message(
      'Takyk islegleriňizi düzüň',
      name: 'takyk_isleglerini_duzun',
      desc: '',
      args: [],
    );
  }

  /// `Öň görülen önümleriň taryhyndan söwda teklibi alyň`
  String get on_gorulen_onumler_section {
    return Intl.message(
      'Öň görülen önümleriň taryhyndan söwda teklibi alyň',
      name: 'on_gorulen_onumler_section',
      desc: '',
      args: [],
    );
  }

  /// `ÖBS`
  String get obs {
    return Intl.message('ÖBS', name: 'obs', desc: '', args: []);
  }

  /// `Gözlege basanda`
  String get gozlege_basanda {
    return Intl.message(
      'Gözlege basanda',
      name: 'gozlege_basanda',
      desc: '',
      args: [],
    );
  }

  /// `Jikme-jik talaplary giriziň`
  String get jikme_jik_talaplary_girizin {
    return Intl.message(
      'Jikme-jik talaplary giriziň',
      name: 'jikme_jik_talaplary_girizin',
      desc: '',
      args: [],
    );
  }

  /// `Üpjünçilerden has takyk söwda tekliplerini almak üçin jikme-jik talaplaryny ýazyň`
  String get jikme_jik_talaplary_hint {
    return Intl.message(
      'Üpjünçilerden has takyk söwda tekliplerini almak üçin jikme-jik talaplaryny ýazyň',
      name: 'jikme_jik_talaplary_hint',
      desc: '',
      args: [],
    );
  }

  /// `Möçberi giriziň`
  String get mocberi_girizin {
    return Intl.message(
      'Möçberi giriziň',
      name: 'mocberi_girizin',
      desc: '',
      args: [],
    );
  }

  /// `Surat goş`
  String get surat_gos {
    return Intl.message('Surat goş', name: 'surat_gos', desc: '', args: []);
  }

  /// `Я готов(a) предоставить свою визитку поставщикам, опубликовавшим свои ценовые предложения.`
  String get rfq_checkbox1 {
    return Intl.message(
      'Я готов(a) предоставить свою визитку поставщикам, опубликовавшим свои ценовые предложения.',
      name: 'rfq_checkbox1',
      desc: '',
      args: [],
    );
  }

  /// `Я прочитал(а), понял(а) и соглашаюсь выполнять правила публикации запросов на покупку satyn almak boýunça sargytlary neşir etmegiň düzgünleri`
  String get rfq_checkbox2 {
    return Intl.message(
      'Я прочитал(а), понял(а) и соглашаюсь выполнять правила публикации запросов на покупку satyn almak boýunça sargytlary neşir etmegiň düzgünleri',
      name: 'rfq_checkbox2',
      desc: '',
      args: [],
    );
  }

  /// `Ugrat`
  String get ugrat {
    return Intl.message('Ugrat', name: 'ugrat', desc: '', args: []);
  }

  /// `sany`
  String get unit_sany {
    return Intl.message('sany', name: 'unit_sany', desc: '', args: []);
  }

  /// `kg`
  String get unit_kg {
    return Intl.message('kg', name: 'unit_kg', desc: '', args: []);
  }

  /// `litr`
  String get unit_litr {
    return Intl.message('litr', name: 'unit_litr', desc: '', args: []);
  }

  /// `m`
  String get unit_m {
    return Intl.message('m', name: 'unit_m', desc: '', args: []);
  }

  /// `sm`
  String get unit_sm {
    return Intl.message('sm', name: 'unit_sm', desc: '', args: []);
  }

  /// `Registrasiýa bolmak`
  String get register {
    return Intl.message(
      'Registrasiýa bolmak',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Ady`
  String get ady {
    return Intl.message('Ady', name: 'ady', desc: '', args: []);
  }

  /// `Familiýasy`
  String get familiasy {
    return Intl.message('Familiýasy', name: 'familiasy', desc: '', args: []);
  }

  /// `E-poçta`
  String get e_pocta {
    return Intl.message('E-poçta', name: 'e_pocta', desc: '', args: []);
  }

  /// `Parol`
  String get parol {
    return Intl.message('Parol', name: 'parol', desc: '', args: []);
  }

  /// `Doglan güni`
  String get doglan_guni {
    return Intl.message('Doglan güni', name: 'doglan_guni', desc: '', args: []);
  }

  /// `Hasap açmak`
  String get hasap_ac {
    return Intl.message('Hasap açmak', name: 'hasap_ac', desc: '', args: []);
  }

  /// `Hökmany`
  String get hokmany {
    return Intl.message('Hökmany', name: 'hokmany', desc: '', args: []);
  }

  /// `Sazlamalar`
  String get settings {
    return Intl.message('Sazlamalar', name: 'settings', desc: '', args: []);
  }

  /// `Pul birligi`
  String get currency {
    return Intl.message('Pul birligi', name: 'currency', desc: '', args: []);
  }

  /// `Bildirişler`
  String get notifications {
    return Intl.message(
      'Bildirişler',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Ulanyjyny pozmak`
  String get delete_user {
    return Intl.message(
      'Ulanyjyny pozmak',
      name: 'delete_user',
      desc: '',
      args: [],
    );
  }

  /// `Wersiýa`
  String get version {
    return Intl.message('Wersiýa', name: 'version', desc: '', args: []);
  }

  /// `Bahalandyrmak`
  String get bahalandyrmak {
    return Intl.message(
      'Bahalandyrmak',
      name: 'bahalandyrmak',
      desc: '',
      args: [],
    );
  }

  /// `Keş arassalamak`
  String get kes_arassalamak {
    return Intl.message(
      'Keş arassalamak',
      name: 'kes_arassalamak',
      desc: '',
      args: [],
    );
  }

  /// `Çykyş`
  String get log_out {
    return Intl.message('Çykyş', name: 'log_out', desc: '', args: []);
  }

  /// `Hakykatdanam ulgamdan çykmak isleýärsiňizmi?`
  String get log_out_desc {
    return Intl.message(
      'Hakykatdanam ulgamdan çykmak isleýärsiňizmi?',
      name: 'log_out_desc',
      desc: '',
      args: [],
    );
  }

  /// `Hawa`
  String get hawa {
    return Intl.message('Hawa', name: 'hawa', desc: '', args: []);
  }

  /// `Ýok`
  String get yok {
    return Intl.message('Ýok', name: 'yok', desc: '', args: []);
  }

  /// `Ulgamdan çykdyňyz`
  String get ulgamdan_cykdynyz {
    return Intl.message(
      'Ulgamdan çykdyňyz',
      name: 'ulgamdan_cykdynyz',
      desc: '',
      args: [],
    );
  }

  /// `Hoş geldiňiz`
  String get welcome {
    return Intl.message('Hoş geldiňiz', name: 'welcome', desc: '', args: []);
  }

  /// `Top satyjylar`
  String get top_satyjylar {
    return Intl.message(
      'Top satyjylar',
      name: 'top_satyjylar',
      desc: '',
      args: [],
    );
  }

  /// `Ýer`
  String get yer {
    return Intl.message('Ýer', name: 'yer', desc: '', args: []);
  }

  /// `Satyjy`
  String get satyjy {
    return Intl.message('Satyjy', name: 'satyjy', desc: '', args: []);
  }

  /// `Haryt sany`
  String get haryt_sany {
    return Intl.message('Haryt sany', name: 'haryt_sany', desc: '', args: []);
  }

  /// `Müşderi baha reýting`
  String get musderi_baha_reyting {
    return Intl.message(
      'Müşderi baha reýting',
      name: 'musderi_baha_reyting',
      desc: '',
      args: [],
    );
  }

  /// `Satyş sany`
  String get satys_sany {
    return Intl.message('Satyş sany', name: 'satys_sany', desc: '', args: []);
  }

  /// `Kurýer tizligi`
  String get kuryer_tizligi {
    return Intl.message(
      'Kurýer tizligi',
      name: 'kuryer_tizligi',
      desc: '',
      args: [],
    );
  }

  /// `Likelar`
  String get like {
    return Intl.message('Likelar', name: 'like', desc: '', args: []);
  }

  /// `Umumy ball`
  String get umumy_ball {
    return Intl.message('Umumy ball', name: 'umumy_ball', desc: '', args: []);
  }

  /// `SEBEDE GOŞ`
  String get sebede_gos {
    return Intl.message('SEBEDE GOŞ', name: 'sebede_gos', desc: '', args: []);
  }

  /// `öz pikiriňi ýaz`
  String get oz_pikirini_yaz {
    return Intl.message(
      'öz pikiriňi ýaz',
      name: 'oz_pikirini_yaz',
      desc: '',
      args: [],
    );
  }

  /// `SOWGAT BER`
  String get sowgat_ber {
    return Intl.message('SOWGAT BER', name: 'sowgat_ber', desc: '', args: []);
  }

  /// `Agza bolanlarym`
  String get agza_bolanlarym {
    return Intl.message(
      'Agza bolanlarym',
      name: 'agza_bolanlarym',
      desc: '',
      args: [],
    );
  }

  /// `Öz şäherimdäkiler`
  String get oz_saherimdaki {
    return Intl.message(
      'Öz şäherimdäkiler',
      name: 'oz_saherimdaki',
      desc: '',
      args: [],
    );
  }

  /// `Umumy`
  String get umumy {
    return Intl.message('Umumy', name: 'umumy', desc: '', args: []);
  }

  /// `Udalit et`
  String get udalit_et {
    return Intl.message('Udalit et', name: 'udalit_et', desc: '', args: []);
  }

  /// `Posty öňüňden çykmaz ýaly udalit et`
  String get posty_udalit_et {
    return Intl.message(
      'Posty öňüňden çykmaz ýaly udalit et',
      name: 'posty_udalit_et',
      desc: '',
      args: [],
    );
  }

  /// `Akkaundy blokla`
  String get akkaundy_blokla {
    return Intl.message(
      'Akkaundy blokla',
      name: 'akkaundy_blokla',
      desc: '',
      args: [],
    );
  }

  /// `Şul akkaunda degişli hiç bir wideo görkezme`
  String get sul_akkaunda_degisli_wideo_gorkezme {
    return Intl.message(
      'Şul akkaunda degişli hiç bir wideo görkezme',
      name: 'sul_akkaunda_degisli_wideo_gorkezme',
      desc: '',
      args: [],
    );
  }

  /// `Profile arza et`
  String get profile_arza_et {
    return Intl.message(
      'Profile arza et',
      name: 'profile_arza_et',
      desc: '',
      args: [],
    );
  }

  /// `Men şul akkauntyň bir zadyndan närazy`
  String get Men_sul_akkauntdan_narazy {
    return Intl.message(
      'Men şul akkauntyň bir zadyndan närazy',
      name: 'Men_sul_akkauntdan_narazy',
      desc: '',
      args: [],
    );
  }

  /// `Balans`
  String get balance {
    return Intl.message('Balans', name: 'balance', desc: '', args: []);
  }

  /// `Goralan`
  String get goralan {
    return Intl.message('Goralan', name: 'goralan', desc: '', args: []);
  }

  /// `Garaşylýan mukdar TMT`
  String get garashylyan_mukdar {
    return Intl.message(
      'Garaşylýan mukdar TMT',
      name: 'garashylyan_mukdar',
      desc: '',
      args: [],
    );
  }

  /// `MBIUM ballar`
  String get MBIUM_ballar {
    return Intl.message(
      'MBIUM ballar',
      name: 'MBIUM_ballar',
      desc: '',
      args: [],
    );
  }

  /// `Bal satyn alnyşy`
  String get bal_satyn_alnyshy {
    return Intl.message(
      'Bal satyn alnyşy',
      name: 'bal_satyn_alnyshy',
      desc: '',
      args: [],
    );
  }

  /// `Tranzaksiýalar`
  String get tranzaksiyalar {
    return Intl.message(
      'Tranzaksiýalar',
      name: 'tranzaksiyalar',
      desc: '',
      args: [],
    );
  }

  /// `Efirlerden baýrak alyň`
  String get efirlerden_bayrak_alyn {
    return Intl.message(
      'Efirlerden baýrak alyň',
      name: 'efirlerden_bayrak_alyn',
      desc: '',
      args: [],
    );
  }

  /// `Has köp gözleýji we sowgatlar alyň!`
  String get gozleyji_we_sowgatlar_alyn {
    return Intl.message(
      'Has köp gözleýji we sowgatlar alyň!',
      name: 'gozleyji_we_sowgatlar_alyn',
      desc: '',
      args: [],
    );
  }

  /// `Geç`
  String get gech {
    return Intl.message('Geç', name: 'gech', desc: '', args: []);
  }

  /// `Efirlerden baýraklar we sowgatlar`
  String get efirlerden_bayraklar_sowgatlar {
    return Intl.message(
      'Efirlerden baýraklar we sowgatlar',
      name: 'efirlerden_bayraklar_sowgatlar',
      desc: '',
      args: [],
    );
  }

  /// `Sazlamalar`
  String get sazlamalar {
    return Intl.message('Sazlamalar', name: 'sazlamalar', desc: '', args: []);
  }

  /// `Töleg usuly`
  String get toleg_usuly {
    return Intl.message('Töleg usuly', name: 'toleg_usuly', desc: '', args: []);
  }

  /// `Şahsyýetiňi tassyklamak`
  String get shahsyyetini_tassyklamak {
    return Intl.message(
      'Şahsyýetiňi tassyklamak',
      name: 'shahsyyetini_tassyklamak',
      desc: '',
      args: [],
    );
  }

  /// `Kömek we seslenmeler`
  String get komek_seslenme {
    return Intl.message(
      'Kömek we seslenmeler',
      name: 'komek_seslenme',
      desc: '',
      args: [],
    );
  }

  /// `Şahsyýetiňiz tassyklandy`
  String get shahsyyetiniz_tassyklandy {
    return Intl.message(
      'Şahsyýetiňiz tassyklandy',
      name: 'shahsyyetiniz_tassyklandy',
      desc: '',
      args: [],
    );
  }

  /// `Tassyklama tapgyrlary`
  String get tassyklama_tapgyrlary {
    return Intl.message(
      'Tassyklama tapgyrlary',
      name: 'tassyklama_tapgyrlary',
      desc: '',
      args: [],
    );
  }

  /// `Şahsy maglumatlaryňyzy iberiň`
  String get shahsy_maglumatlaryny_iber {
    return Intl.message(
      'Şahsy maglumatlaryňyzy iberiň',
      name: 'shahsy_maglumatlaryny_iber',
      desc: '',
      args: [],
    );
  }

  /// `Maglumatlar barlanýar`
  String get maglumatlar_barlanyar {
    return Intl.message(
      'Maglumatlar barlanýar',
      name: 'maglumatlar_barlanyar',
      desc: '',
      args: [],
    );
  }

  /// `Hasabym`
  String get hasabym {
    return Intl.message('Hasabym', name: 'hasabym', desc: '', args: []);
  }

  /// `Agramy`
  String get agramy {
    return Intl.message('Agramy', name: 'agramy', desc: '', args: []);
  }

  /// `Barkod`
  String get barkode {
    return Intl.message('Barkod', name: 'barkode', desc: '', args: []);
  }

  /// `Öndüriji`
  String get onduriji {
    return Intl.message('Öndüriji', name: 'onduriji', desc: '', args: []);
  }

  /// `Teswirler`
  String get teswirler {
    return Intl.message('Teswirler', name: 'teswirler', desc: '', args: []);
  }

  /// `Dükan tapylmady`
  String get shop_empty {
    return Intl.message(
      'Dükan tapylmady',
      name: 'shop_empty',
      desc: '',
      args: [],
    );
  }

  /// `Ählisi`
  String get all {
    return Intl.message('Ählisi', name: 'all', desc: '', args: []);
  }

  /// `Gorag`
  String get gorag {
    return Intl.message('Gorag', name: 'gorag', desc: '', args: []);
  }

  /// `Sargydyňyzy nädip gorap bilersiňiz`
  String get sargydynyz_nadip_gorap_bilersiniz {
    return Intl.message(
      'Sargydyňyzy nädip gorap bilersiňiz',
      name: 'sargydynyz_nadip_gorap_bilersiniz',
      desc: '',
      args: [],
    );
  }

  /// `Özüňiz sargyt edeniňizde`
  String get onuniz_ozuniz_alynyz_goragy {
    return Intl.message(
      'Özüňiz sargyt edeniňizde',
      name: 'onuniz_ozuniz_alynyz_goragy',
      desc: '',
      args: [],
    );
  }

  /// `Sizi sargydyňyz haryt sahypasynda «Sargyt et» düwmesine basan pursatyňyzdan goralýar.`
  String get sargyt_gorag_desc1 {
    return Intl.message(
      'Sizi sargydyňyz haryt sahypasynda «Sargyt et» düwmesine basan pursatyňyzdan goralýar.',
      name: 'sargyt_gorag_desc1',
      desc: '',
      args: [],
    );
  }

  /// `Когда поставщик готовит для вас заказ:`
  String get kogda {
    return Intl.message(
      'Когда поставщик готовит для вас заказ:',
      name: 'kogda',
      desc: '',
      args: [],
    );
  }

  /// `Pöwre size sargyt taýýarlaýarka: Mbium.com-da sargyt üçin tölegi "Meniň profilim" > <<Sargytlar>> bölümine geçip amala aşyryň. Bank geçirim arkaly töläniňizde, geçirim Mbium.com-yň resmi bank hasabyna edilendigine göz ýetiriň`
  String get kogda_desk {
    return Intl.message(
      'Pöwre size sargyt taýýarlaýarka: Mbium.com-da sargyt üçin tölegi "Meniň profilim" > <<Sargytlar>> bölümine geçip amala aşyryň. Bank geçirim arkaly töläniňizde, geçirim Mbium.com-yň resmi bank hasabyna edilendigine göz ýetiriň',
      name: 'kogda_desk',
      desc: '',
      args: [],
    );
  }

  /// `Howpsuz tölegler`
  String get hopwsuz_toleg {
    return Intl.message(
      'Howpsuz tölegler',
      name: 'hopwsuz_toleg',
      desc: '',
      args: [],
    );
  }

  /// `Halan ýerli töleg usullarňyzdan, walýutalaryňyzdan, bank geçirimleriňizden ýa-da garaşrykly töleg meýilnamalarňyzdan saýlaň`
  String get hopwsuz_toleg_des {
    return Intl.message(
      'Halan ýerli töleg usullarňyzdan, walýutalaryňyzdan, bank geçirimleriňizden ýa-da garaşrykly töleg meýilnamalarňyzdan saýlaň',
      name: 'hopwsuz_toleg_des',
      desc: '',
      args: [],
    );
  }

  /// `Mbium.com arkaly amala aşyrylýan her bir geleşik, maglumat howpsuzlygynyň SSL şifrlemesi we PCI DSS protokollary arkaly goralýar`
  String get hopwsuz_toleg_deskk {
    return Intl.message(
      'Mbium.com arkaly amala aşyrylýan her bir geleşik, maglumat howpsuzlygynyň SSL şifrlemesi we PCI DSS protokollary arkaly goralýar',
      name: 'hopwsuz_toleg_deskk',
      desc: '',
      args: [],
    );
  }

  /// `Howpsuz tölegler barada has giňişleýin`
  String get howpsuz_tolegler_has_ginisleyin {
    return Intl.message(
      'Howpsuz tölegler barada has giňişleýin',
      name: 'howpsuz_tolegler_has_ginisleyin',
      desc: '',
      args: [],
    );
  }

  /// `что ваш заказ будет отправлен или доставлен в гарантированные сроки.`
  String get bash_zakaz {
    return Intl.message(
      'что ваш заказ будет отправлен или доставлен в гарантированные сроки.',
      name: 'bash_zakaz',
      desc: '',
      args: [],
    );
  }

  /// `В редких случаях задержки вы получите компенсацию в размере 10% от общей суммы заказа.`
  String get redkih {
    return Intl.message(
      'В редких случаях задержки вы получите компенсацию в размере 10% от общей суммы заказа.',
      name: 'redkih',
      desc: '',
      args: [],
    );
  }

  /// `Подробнее о возврате товаров и средств`
  String get podrobnoye {
    return Intl.message(
      'Подробнее о возврате товаров и средств',
      name: 'podrobnoye',
      desc: '',
      args: [],
    );
  }

  /// `Töleg gaýtarmak goragy`
  String get tolog_gaytarmak_goragy {
    return Intl.message(
      'Töleg gaýtarmak goragy',
      name: 'tolog_gaytarmak_goragy',
      desc: '',
      args: [],
    );
  }

  /// `Eger sargydyňyz gowşurylmasa, ýitse ýa-da kemçilikli ýa-da zeperli ýagdaýda gowşurylsa.`
  String get tolog_gaytarmak_desc {
    return Intl.message(
      'Eger sargydyňyz gowşurylmasa, ýitse ýa-da kemçilikli ýa-da zeperli ýagdaýda gowşurylsa.',
      name: 'tolog_gaytarmak_desc',
      desc: '',
      args: [],
    );
  }

  /// `Harytlary we serişdeleri gaýtarmak barada has giňişleýin`
  String get haryt_gaytarmak {
    return Intl.message(
      'Harytlary we serişdeleri gaýtarmak barada has giňişleýin',
      name: 'haryt_gaytarmak',
      desc: '',
      args: [],
    );
  }

  /// `Gije-gündizleýin goldaw`
  String get gije_gundizleyin_goldaw_title {
    return Intl.message(
      'Gije-gündizleýin goldaw',
      name: 'gije_gundizleyin_goldaw_title',
      desc: '',
      args: [],
    );
  }

  /// `Sargytlar, şikaýatlar ýa-da soraglar bilen baglanyşykly soraglary çözmek üçin biziň gije-gündizleýin wirtual maglumat merkezimizden peýdalanyň ýa-da iş wagtynda işgärlerimiz bilen habarlaşyň.`
  String get gije_gundizleyin_goldaw_desc {
    return Intl.message(
      'Sargytlar, şikaýatlar ýa-da soraglar bilen baglanyşykly soraglary çözmek üçin biziň gije-gündizleýin wirtual maglumat merkezimizden peýdalanyň ýa-da iş wagtynda işgärlerimiz bilen habarlaşyň.',
      name: 'gije_gundizleyin_goldaw_desc',
      desc: '',
      args: [],
    );
  }

  /// `Maglumatlaryň gizlinligi`
  String get maglumatlaryn_gizlinligi {
    return Intl.message(
      'Maglumatlaryň gizlinligi',
      name: 'maglumatlaryn_gizlinligi',
      desc: '',
      args: [],
    );
  }

  /// `Biz siziň razylygyňyz bolmazdan maglumatlaryny hiç haçan üçinji şahslara bermeýäris. Ähli şahsy maglumatlar Mbium.com-yň maglumatlaryň gizlinligi syýasatyna laýyklykda işlenilýär.`
  String get maglumatlaryn_gizlinligi_desc {
    return Intl.message(
      'Biz siziň razylygyňyz bolmazdan maglumatlaryny hiç haçan üçinji şahslara bermeýäris. Ähli şahsy maglumatlar Mbium.com-yň maglumatlaryň gizlinligi syýasatyna laýyklykda işlenilýär.',
      name: 'maglumatlaryn_gizlinligi_desc',
      desc: '',
      args: [],
    );
  }

  /// `Biz size nädip kömek edip bileris?`
  String get biz_size_nadip_komek {
    return Intl.message(
      'Biz size nädip kömek edip bileris?',
      name: 'biz_size_nadip_komek',
      desc: '',
      args: [],
    );
  }

  /// `Gözläň ýa-da sorag beriň`
  String get gozlayish_ya_da_sorag_berin {
    return Intl.message(
      'Gözläň ýa-da sorag beriň',
      name: 'gozlayish_ya_da_sorag_berin',
      desc: '',
      args: [],
    );
  }

  /// `Hyzmat haýyşynyň taryhy...`
  String get hyzmat_hayysyny_taryh {
    return Intl.message(
      'Hyzmat haýyşynyň taryhy...',
      name: 'hyzmat_hayysyny_taryh',
      desc: '',
      args: [],
    );
  }

  /// `Maslahat berilýär`
  String get maslahat_beriyor {
    return Intl.message(
      'Maslahat berilýär',
      name: 'maslahat_beriyor',
      desc: '',
      args: [],
    );
  }

  /// `Harydymy haçan alaryn?`
  String get harydy_hacan_alaryn {
    return Intl.message(
      'Harydymy haçan alaryn?',
      name: 'harydy_hacan_alaryn',
      desc: '',
      args: [],
    );
  }

  /// `Söwda kepilligi bolan sargydym boýunça jedel nädip açmaly?`
  String get sowda_kepilligindaki_sargydymy {
    return Intl.message(
      'Söwda kepilligi bolan sargydym boýunça jedel nädip açmaly?',
      name: 'sowda_kepilligindaki_sargydymy',
      desc: '',
      args: [],
    );
  }

  /// `Trade Assurance bilen goralýan sargyt jedelini nädip çözmeli?`
  String get trade_assurance_bilen_goralyan_sargyt {
    return Intl.message(
      'Trade Assurance bilen goralýan sargyt jedelini nädip çözmeli?',
      name: 'trade_assurance_bilen_goralyan_sargyt',
      desc: '',
      args: [],
    );
  }

  /// `Bu üpjün edijiniň ýagtybarlylygyny nädip bilip bilerin?`
  String get bu_ucin_edijilik_yagtybarlylygyny {
    return Intl.message(
      'Bu üpjün edijiniň ýagtybarlylygyny nädip bilip bilerin?',
      name: 'bu_ucin_edijilik_yagtybarlylygyny',
      desc: '',
      args: [],
    );
  }

  /// `Harytlar bilen baglanyşykly problema ýüze çyksa näme etmeli?`
  String get haryt_bilen_baglanyshykly_problema {
    return Intl.message(
      'Harytlar bilen baglanyşykly problema ýüze çyksa näme etmeli?',
      name: 'haryt_bilen_baglanyshykly_problema',
      desc: '',
      args: [],
    );
  }

  /// `KSS`
  String get kss {
    return Intl.message('KSS', name: 'kss', desc: '', args: []);
  }

  /// `Ählisini görkez`
  String get ahlisin_gorkez {
    return Intl.message(
      'Ählisini görkez',
      name: 'ahlisin_gorkez',
      desc: '',
      args: [],
    );
  }

  /// `Trade Assurance bilen sargyt nädip etmeli?`
  String get trade_assurance_bilen_sargyt {
    return Intl.message(
      'Trade Assurance bilen sargyt nädip etmeli?',
      name: 'trade_assurance_bilen_sargyt',
      desc: '',
      args: [],
    );
  }

  /// `Maglumat goragy`
  String get maglumat_goragy {
    return Intl.message(
      'Maglumat goragy',
      name: 'maglumat_goragy',
      desc: '',
      args: [],
    );
  }

  /// `Biz şahsy maglumatlary diňe anyk, çäklendirilen maksatlar üçin we hereket edýän kanunçylyga laýyklykda işleýäris.`
  String get maglumat_goragy_desc {
    return Intl.message(
      'Biz şahsy maglumatlary diňe anyk, çäklendirilen maksatlar üçin we hereket edýän kanunçylyga laýyklykda işleýäris.',
      name: 'maglumat_goragy_desc',
      desc: '',
      args: [],
    );
  }

  /// `Biz maglumatlary ýygnamagy iň pes derejede saklamaga çalyşýarys we olary saklamak möhletlerini çäklendirýäris, hyzmatlarymyzyň içine gizlinligini gurnaýarys we şahsy maglumatlaryňyzy ulanmakda aýdyňlygy üpjün edýäris.`
  String get maglumat_desk {
    return Intl.message(
      'Biz maglumatlary ýygnamagy iň pes derejede saklamaga çalyşýarys we olary saklamak möhletlerini çäklendirýäris, hyzmatlarymyzyň içine gizlinligini gurnaýarys we şahsy maglumatlaryňyzy ulanmakda aýdyňlygy üpjün edýäris.',
      name: 'maglumat_desk',
      desc: '',
      args: [],
    );
  }

  /// `Howpsuzlyk çäreleri`
  String get howpuszlyk_caryaleri {
    return Intl.message(
      'Howpsuzlyk çäreleri',
      name: 'howpuszlyk_caryaleri',
      desc: '',
      args: [],
    );
  }

  /// `Biz rugsatsyz girişiň öňüni almak, maglumatlaryň takyklygyny saklamak we bizde saklanýan maglumatlary goramak üçin tehniki we guramaçylyk çärelerini ulanýarys.`
  String get howpsuzlyk_caryaleri_desc {
    return Intl.message(
      'Biz rugsatsyz girişiň öňüni almak, maglumatlaryň takyklygyny saklamak we bizde saklanýan maglumatlary goramak üçin tehniki we guramaçylyk çärelerini ulanýarys.',
      name: 'howpsuzlyk_caryaleri_desc',
      desc: '',
      args: [],
    );
  }

  /// `Öz maglumatlarňyzy dolandyryň`
  String get oz_maglumatlarynyzyn_dolandyryn {
    return Intl.message(
      'Öz maglumatlarňyzy dolandyryň',
      name: 'oz_maglumatlarynyzyn_dolandyryn',
      desc: '',
      args: [],
    );
  }

  /// `Siz öz şahsy maglumatlaryňyza bolan gözegiçligi saklaýarsyňyz. Biz siziň haýyşyňyza dessine we hereket edýän maglumat goragy baradaky kanunlara we kadalara laýyklykda jogap bereris.`
  String get oz_maglumatlarynyzyn_dolandyryn_desc {
    return Intl.message(
      'Siz öz şahsy maglumatlaryňyza bolan gözegiçligi saklaýarsyňyz. Biz siziň haýyşyňyza dessine we hereket edýän maglumat goragy baradaky kanunlara we kadalara laýyklykda jogap bereris.',
      name: 'oz_maglumatlarynyzyn_dolandyryn_desc',
      desc: '',
      args: [],
    );
  }

  /// `Biz bilen gije gündiz habarlaşyň ýa-da yzygiderli täzelenýän maglumat merkezimizden peýdalanyň. Biz elmydama kömek etmäge taýýar.`
  String get gije_gundizleyin_goldaw_page_title {
    return Intl.message(
      'Biz bilen gije gündiz habarlaşyň ýa-da yzygiderli täzelenýän maglumat merkezimizden peýdalanyň. Biz elmydama kömek etmäge taýýar.',
      name: 'gije_gundizleyin_goldaw_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Hünärmenleriň islendik wagtlaýyn kömegi`
  String get hunarmenlerin_islender_wagtlayin_komegi {
    return Intl.message(
      'Hünärmenleriň islendik wagtlaýyn kömegi',
      name: 'hunarmenlerin_islender_wagtlayin_komegi',
      desc: '',
      args: [],
    );
  }

  /// `Programmada ýa-da Mbium.com saýtynda noutbugyňyzda goldaw alyň. Biz professional hünärmenlerimiz siziň zerurlyklarňyzy düşüner we islendik talaplaryny - haçan sazlamanyzdan başlap, satuwdan soňky hyzmatlara çenli, operatiw we hünärmen derejesinde işlär.`
  String get hunarmenlerin_islender_desc {
    return Intl.message(
      'Programmada ýa-da Mbium.com saýtynda noutbugyňyzda goldaw alyň. Biz professional hünärmenlerimiz siziň zerurlyklarňyzy düşüner we islendik talaplaryny - haçan sazlamanyzdan başlap, satuwdan soňky hyzmatlara çenli, operatiw we hünärmen derejesinde işlär.',
      name: 'hunarmenlerin_islender_desc',
      desc: '',
      args: [],
    );
  }

  /// `Dürli dillerde jogap berýäris`
  String get durli_dillerde_jogap_beryaris {
    return Intl.message(
      'Dürli dillerde jogap berýäris',
      name: 'durli_dillerde_jogap_beryaris',
      desc: '',
      args: [],
    );
  }

  /// `Biz siziň üçin amatly dilde problemalaryňyzy ynamdar we çalt çözmäge çalyşýarys. Hyzmatlarymyzy 10-dan gowrak dilde hödürleýäris.`
  String get durli_dillerde_desc {
    return Intl.message(
      'Biz siziň üçin amatly dilde problemalaryňyzy ynamdar we çalt çözmäge çalyşýarys. Hyzmatlarymyzy 10-dan gowrak dilde hödürleýäris.',
      name: 'durli_dillerde_desc',
      desc: '',
      args: [],
    );
  }

  /// `Jedelleri çözmek`
  String get jedelleri_coz_goldaw {
    return Intl.message(
      'Jedelleri çözmek',
      name: 'jedelleri_coz_goldaw',
      desc: '',
      args: [],
    );
  }

  /// `Eger geleşik wagtynda siz şulardan haýsydyr biri bilen ýüzbe-ýüz bolduňyz, mysal üçin, üpjün edijiniň harydy ibermekden ýüz öwürmegi, baha ýokarlandyrma, şertleşilen möhletlerde eltip bermegiň ýerine ýetirilmezligi, ýalan maglumat berilmegi, ýa-da harydyň sypatnamasyna laýyk gelmezligi ýa-da harydyň sypatnamasyna laýyk gelmezligi ýa-da sypatnamasy, siz jedeli jedel gorag möwritiniň dowamynda Trade Assurance-da açyp bilersiňiz. Mbium.com siziň hukuklaryňyzy we bähbitleriňizi tutuş geleşigiň dowamynda goraýar.`
  String get jedelleri_coz_goldaw_desc {
    return Intl.message(
      'Eger geleşik wagtynda siz şulardan haýsydyr biri bilen ýüzbe-ýüz bolduňyz, mysal üçin, üpjün edijiniň harydy ibermekden ýüz öwürmegi, baha ýokarlandyrma, şertleşilen möhletlerde eltip bermegiň ýerine ýetirilmezligi, ýalan maglumat berilmegi, ýa-da harydyň sypatnamasyna laýyk gelmezligi ýa-da harydyň sypatnamasyna laýyk gelmezligi ýa-da sypatnamasy, siz jedeli jedel gorag möwritiniň dowamynda Trade Assurance-da açyp bilersiňiz. Mbium.com siziň hukuklaryňyzy we bähbitleriňizi tutuş geleşigiň dowamynda goraýar.',
      name: 'jedelleri_coz_goldaw_desc',
      desc: '',
      args: [],
    );
  }

  /// `Jedelleri çözmek düzgünleri barada has giňişleýin`
  String get goldaw_has_ginisleyin {
    return Intl.message(
      'Jedelleri çözmek düzgünleri barada has giňişleýin',
      name: 'goldaw_has_ginisleyin',
      desc: '',
      args: [],
    );
  }

  /// `Kepillendirilen gowşuryş`
  String get kepillendirilen_gowsurysh {
    return Intl.message(
      'Kepillendirilen gowşuryş',
      name: 'kepillendirilen_gowsurysh',
      desc: '',
      args: [],
    );
  }

  /// `Kämilleşdirilen meýilleşdirme we ätiýaçlygy dolandyrmak üçin, sargydyňyzyň kepillendirilen möhletlerde iberiljekdigini ýa-da gowşuryljakdygyny bilip peýdalanyň. Gijikdirilmeliň seýrek ýagdaýlarynda, sargydyňyzyň umumy bahasynyň 10%-i möçberinde (maksimum 100 ABŞ dollaryna çenli) kompensasiýa alarsyňyz.`
  String get kepillendirilen_gowsurysh_desc {
    return Intl.message(
      'Kämilleşdirilen meýilleşdirme we ätiýaçlygy dolandyrmak üçin, sargydyňyzyň kepillendirilen möhletlerde iberiljekdigini ýa-da gowşuryljakdygyny bilip peýdalanyň. Gijikdirilmeliň seýrek ýagdaýlarynda, sargydyňyzyň umumy bahasynyň 10%-i möçberinde (maksimum 100 ABŞ dollaryna çenli) kompensasiýa alarsyňyz.',
      name: 'kepillendirilen_gowsurysh_desc',
      desc: '',
      args: [],
    );
  }

  /// `Ynamdar tölegler`
  String get ynamdar_tolegler {
    return Intl.message(
      'Ynamdar tölegler',
      name: 'ynamdar_tolegler',
      desc: '',
      args: [],
    );
  }

  /// `Mbium.com-da eden her bir tölegiňiz berk SSL şifrleme we PCI DSS gizlinlik protokollary bilen goralýar, şonuň üçin şahsy maglumatlaryňyz elmydama ygtybarlydyr.`
  String get ynamdar_tolegler_desc {
    return Intl.message(
      'Mbium.com-da eden her bir tölegiňiz berk SSL şifrleme we PCI DSS gizlinlik protokollary bilen goralýar, şonuň üçin şahsy maglumatlaryňyz elmydama ygtybarlydyr.',
      name: 'ynamdar_tolegler_desc',
      desc: '',
      args: [],
    );
  }

  /// `Tölegiňizi goramak üçin elmydama Mbium.com-yň resmi töleg kanallaryndan peýdalanyň.`
  String get ynamdar_desk {
    return Intl.message(
      'Tölegiňizi goramak üçin elmydama Mbium.com-yň resmi töleg kanallaryndan peýdalanyň.',
      name: 'ynamdar_desk',
      desc: '',
      args: [],
    );
  }

  /// `Dürli görnüşli töleg usullary`
  String get durli_gornushli_tolog_usullary {
    return Intl.message(
      'Dürli görnüşli töleg usullary',
      name: 'durli_gornushli_tolog_usullary',
      desc: '',
      args: [],
    );
  }

  /// `Tölegleriňizi kredit/debit kartlary, PayPal, Apple Pay, Google Pay, Afterpay/Clearpay we beýleki meşhur ýe usullar arkaly onlaýn hasaplaşyk panelimizden amala aşyryp bilersiňiz.`
  String get durli_gornushli_desc {
    return Intl.message(
      'Tölegleriňizi kredit/debit kartlary, PayPal, Apple Pay, Google Pay, Afterpay/Clearpay we beýleki meşhur ýe usullar arkaly onlaýn hasaplaşyk panelimizden amala aşyryp bilersiňiz.',
      name: 'durli_gornushli_desc',
      desc: '',
      args: [],
    );
  }

  /// `Alternatiw hökmünde, siz Mbium.com tarapyndan berlen resmi bank maglumatlaryny ulanyp, esbap goragly bank geçirimini saýlap bilersiňiz.`
  String get alternatiw_hokumde {
    return Intl.message(
      'Alternatiw hökmünde, siz Mbium.com tarapyndan berlen resmi bank maglumatlaryny ulanyp, esbap goragly bank geçirimini saýlap bilersiňiz.',
      name: 'alternatiw_hokumde',
      desc: '',
      args: [],
    );
  }

  /// `Biz 27-den gowrak pul birliginde geleşikleri goldaýarys, şonuň üçin siz pul çalyşmak üçin sarp`
  String get pul {
    return Intl.message(
      'Biz 27-den gowrak pul birliginde geleşikleri goldaýarys, şonuň üçin siz pul çalyşmak üçin sarp',
      name: 'pul',
      desc: '',
      args: [],
    );
  }

  /// `Şertler we kadalar`
  String get sertler_we_kadalar {
    return Intl.message(
      'Şertler we kadalar',
      name: 'sertler_we_kadalar',
      desc: '',
      args: [],
    );
  }

  /// `Bildirişler`
  String get bildirisher {
    return Intl.message('Bildirişler', name: 'bildirisher', desc: '', args: []);
  }

  /// `Ýaňy ýakyndakylar`
  String get yany_yakyndakylar {
    return Intl.message(
      'Ýaňy ýakyndakylar',
      name: 'yany_yakyndakylar',
      desc: '',
      args: [],
    );
  }

  /// `Habarsyz galmaň`
  String get habarsyz_galman {
    return Intl.message(
      'Habarsyz galmaň',
      name: 'habarsyz_galman',
      desc: '',
      args: [],
    );
  }

  /// `Bildirişleri ýakynly we hiç haçan täze aksiyalary we sargytlary görüň.`
  String get bildirisleri_yakynyy {
    return Intl.message(
      'Bildirişleri ýakynly we hiç haçan täze aksiyalary we sargytlary görüň.',
      name: 'bildirisleri_yakynyy',
      desc: '',
      args: [],
    );
  }

  /// `İşlet`
  String get ishlet {
    return Intl.message('İşlet', name: 'ishlet', desc: '', args: []);
  }

  /// `Başga bildirişler`
  String get basha_bildirisher {
    return Intl.message(
      'Başga bildirişler',
      name: 'basha_bildirisher',
      desc: '',
      args: [],
    );
  }

  /// `Harytlar ýok`
  String get harytlar_yok {
    return Intl.message(
      'Harytlar ýok',
      name: 'harytlar_yok',
      desc: '',
      args: [],
    );
  }

  /// `Mugt eltip bermek`
  String get mugt_eltip_bermek {
    return Intl.message(
      'Mugt eltip bermek',
      name: 'mugt_eltip_bermek',
      desc: '',
      args: [],
    );
  }

  /// `maks. 300TMT`
  String get man_maks {
    return Intl.message('maks. 300TMT', name: 'man_maks', desc: '', args: []);
  }

  /// `Salgylaryňyz heniz ýok`
  String get addresses_empty {
    return Intl.message(
      'Salgylaryňyz heniz ýok',
      name: 'addresses_empty',
      desc: '',
      args: [],
    );
  }

  /// `Salgy goşmak`
  String get address_add {
    return Intl.message(
      'Salgy goşmak',
      name: 'address_add',
      desc: '',
      args: [],
    );
  }

  /// `Täze salgy`
  String get address_new {
    return Intl.message('Täze salgy', name: 'address_new', desc: '', args: []);
  }

  /// `Salgyny üýtgetmek`
  String get address_edit {
    return Intl.message(
      'Salgyny üýtgetmek',
      name: 'address_edit',
      desc: '',
      args: [],
    );
  }

  /// `Ady (öý, iş...)`
  String get address_label_hint {
    return Intl.message(
      'Ady (öý, iş...)',
      name: 'address_label_hint',
      desc: '',
      args: [],
    );
  }

  /// `Ady giriziň`
  String get address_label_required {
    return Intl.message(
      'Ady giriziň',
      name: 'address_label_required',
      desc: '',
      args: [],
    );
  }

  /// `Salgy`
  String get address_field_hint {
    return Intl.message(
      'Salgy',
      name: 'address_field_hint',
      desc: '',
      args: [],
    );
  }

  /// `Salgyny giriziň`
  String get address_field_required {
    return Intl.message(
      'Salgyny giriziň',
      name: 'address_field_required',
      desc: '',
      args: [],
    );
  }

  /// `Şäher ID`
  String get address_city_id {
    return Intl.message(
      'Şäher ID',
      name: 'address_city_id',
      desc: '',
      args: [],
    );
  }

  /// `Sebit ID`
  String get address_region_id {
    return Intl.message(
      'Sebit ID',
      name: 'address_region_id',
      desc: '',
      args: [],
    );
  }

  /// `Giňlik`
  String get address_latitude {
    return Intl.message('Giňlik', name: 'address_latitude', desc: '', args: []);
  }

  /// `Uzynlyk`
  String get address_longitude {
    return Intl.message(
      'Uzynlyk',
      name: 'address_longitude',
      desc: '',
      args: [],
    );
  }

  /// `Esasy salgy hökmünde belle`
  String get address_set_default {
    return Intl.message(
      'Esasy salgy hökmünde belle',
      name: 'address_set_default',
      desc: '',
      args: [],
    );
  }

  /// `Esasy`
  String get address_default_badge {
    return Intl.message(
      'Esasy',
      name: 'address_default_badge',
      desc: '',
      args: [],
    );
  }

  /// `Ýatda sakla`
  String get address_save {
    return Intl.message(
      'Ýatda sakla',
      name: 'address_save',
      desc: '',
      args: [],
    );
  }

  /// `Üýtgetmek`
  String get address_edit_menu {
    return Intl.message(
      'Üýtgetmek',
      name: 'address_edit_menu',
      desc: '',
      args: [],
    );
  }

  /// `Pozmak`
  String get address_delete_menu {
    return Intl.message(
      'Pozmak',
      name: 'address_delete_menu',
      desc: '',
      args: [],
    );
  }

  /// `Salgyny pozmalymy?`
  String get address_delete_title {
    return Intl.message(
      'Salgyny pozmalymy?',
      name: 'address_delete_title',
      desc: '',
      args: [],
    );
  }

  /// `Bu hereketi yzyna gaýtaryp bolmaz.`
  String get address_delete_confirm {
    return Intl.message(
      'Bu hereketi yzyna gaýtaryp bolmaz.',
      name: 'address_delete_confirm',
      desc: '',
      args: [],
    );
  }

  /// `Ýatyrmak`
  String get address_cancel {
    return Intl.message('Ýatyrmak', name: 'address_cancel', desc: '', args: []);
  }

  /// `Pozmak`
  String get address_delete_action {
    return Intl.message(
      'Pozmak',
      name: 'address_delete_action',
      desc: '',
      args: [],
    );
  }

  /// `Kartadan saýlamak`
  String get address_pick_on_map {
    return Intl.message(
      'Kartadan saýlamak',
      name: 'address_pick_on_map',
      desc: '',
      args: [],
    );
  }

  /// `Bu ýeri saýla`
  String get address_confirm_location {
    return Intl.message(
      'Bu ýeri saýla',
      name: 'address_confirm_location',
      desc: '',
      args: [],
    );
  }

  /// `Kartadan salgy saýlamak`
  String get address_choose_location {
    return Intl.message(
      'Kartadan salgy saýlamak',
      name: 'address_choose_location',
      desc: '',
      args: [],
    );
  }

  /// `Habarlaş`
  String get habarlas {
    return Intl.message('Habarlaş', name: 'habarlas', desc: '', args: []);
  }

  /// `Jaň et`
  String get jan_et {
    return Intl.message('Jaň et', name: 'jan_et', desc: '', args: []);
  }

  /// `Ýeri`
  String get yeri {
    return Intl.message('Ýeri', name: 'yeri', desc: '', args: []);
  }

  /// `Dükanyň görnüşi`
  String get dukanyn_gornushi {
    return Intl.message(
      'Dükanyň görnüşi',
      name: 'dukanyn_gornushi',
      desc: '',
      args: [],
    );
  }

  /// `Kategoriýalar`
  String get kategoriyalar {
    return Intl.message(
      'Kategoriýalar',
      name: 'kategoriyalar',
      desc: '',
      args: [],
    );
  }

  /// `Kategoriýa ýok`
  String get kategoriya_yok {
    return Intl.message(
      'Kategoriýa ýok',
      name: 'kategoriya_yok',
      desc: '',
      args: [],
    );
  }

  /// `Tassyklanan dükan`
  String get tassyklanan_dukan {
    return Intl.message(
      'Tassyklanan dükan',
      name: 'tassyklanan_dukan',
      desc: '',
      args: [],
    );
  }

  /// `Tassyklanmadyk dükan`
  String get tassyklanmadyk_dukan {
    return Intl.message(
      'Tassyklanmadyk dükan',
      name: 'tassyklanmadyk_dukan',
      desc: '',
      args: [],
    );
  }

  /// `Dükan barada`
  String get dukan_barada {
    return Intl.message(
      'Dükan barada',
      name: 'dukan_barada',
      desc: '',
      args: [],
    );
  }

  /// `Harytlar`
  String get harytlar {
    return Intl.message('Harytlar', name: 'harytlar', desc: '', args: []);
  }

  /// `haryt`
  String get haryt {
    return Intl.message('haryt', name: 'haryt', desc: '', args: []);
  }

  /// `Haryt gözle...`
  String get haryt_gozle {
    return Intl.message(
      'Haryt gözle...',
      name: 'haryt_gozle',
      desc: '',
      args: [],
    );
  }

  /// `Tertiplemek`
  String get tertiplemek {
    return Intl.message('Tertiplemek', name: 'tertiplemek', desc: '', args: []);
  }

  /// `Iň arzan`
  String get in_arzan {
    return Intl.message('Iň arzan', name: 'in_arzan', desc: '', args: []);
  }

  /// `Iň gymmat`
  String get in_gymmat {
    return Intl.message('Iň gymmat', name: 'in_gymmat', desc: '', args: []);
  }

  /// `Iň täze`
  String get in_taze {
    return Intl.message('Iň täze', name: 'in_taze', desc: '', args: []);
  }

  /// `Teswir ýaz...`
  String get teswir_yaz {
    return Intl.message(
      'Teswir ýaz...',
      name: 'teswir_yaz',
      desc: '',
      args: [],
    );
  }

  /// `Iber`
  String get iber {
    return Intl.message('Iber', name: 'iber', desc: '', args: []);
  }

  /// `Entek teswir ýok`
  String get teswirler_heniz_yok {
    return Intl.message(
      'Entek teswir ýok',
      name: 'teswirler_heniz_yok',
      desc: '',
      args: [],
    );
  }

  /// `Häzir`
  String get hazir {
    return Intl.message('Häzir', name: 'hazir', desc: '', args: []);
  }

  /// `Ýerleşişi`
  String get yerleshishi {
    return Intl.message('Ýerleşişi', name: 'yerleshishi', desc: '', args: []);
  }

  /// `Kartada görkez`
  String get kartada_gorkez {
    return Intl.message(
      'Kartada görkez',
      name: 'kartada_gorkez',
      desc: '',
      args: [],
    );
  }

  /// `Eýesi`
  String get eyesi {
    return Intl.message('Eýesi', name: 'eyesi', desc: '', args: []);
  }

  /// `Işleýiş ýagdaýy`
  String get iyleyish_yagdayy {
    return Intl.message(
      'Işleýiş ýagdaýy',
      name: 'iyleyish_yagdayy',
      desc: '',
      args: [],
    );
  }

  /// `Işleýär`
  String get isleyar {
    return Intl.message('Işleýär', name: 'isleyar', desc: '', args: []);
  }

  /// `Işlemeýär`
  String get islemeyar {
    return Intl.message('Işlemeýär', name: 'islemeyar', desc: '', args: []);
  }

  /// `Sorag-jogap`
  String get sorag_jogap {
    return Intl.message('Sorag-jogap', name: 'sorag_jogap', desc: '', args: []);
  }

  /// `Salam, size nähili kömek edip bileris?`
  String get salam_komek {
    return Intl.message(
      'Salam, size nähili kömek edip bileris?',
      name: 'salam_komek',
      desc: '',
      args: [],
    );
  }

  /// `Bu gün`
  String get bu_gun {
    return Intl.message('Bu gün', name: 'bu_gun', desc: '', args: []);
  }

  /// `Adaty jogap wagty: 5-10 minut`
  String get adaty_jogap_wagty {
    return Intl.message(
      'Adaty jogap wagty: 5-10 minut',
      name: 'adaty_jogap_wagty',
      desc: '',
      args: [],
    );
  }

  /// `Soragyňyzy ýazyň...`
  String get soragynyzy_yazyn {
    return Intl.message(
      'Soragyňyzy ýazyň...',
      name: 'soragynyzy_yazyn',
      desc: '',
      args: [],
    );
  }

  /// `Tassyklanan hünärmen öndüriji`
  String get tassyklanan_hunarmen_ondurji {
    return Intl.message(
      'Tassyklanan hünärmen öndüriji',
      name: 'tassyklanan_hunarmen_ondurji',
      desc: '',
      args: [],
    );
  }

  /// `Onlaýn söwda sergisi`
  String get onlayn_sowda_sergisi {
    return Intl.message(
      'Onlaýn söwda sergisi',
      name: 'onlayn_sowda_sergisi',
      desc: '',
      args: [],
    );
  }

  /// `Telefon belgiňiz arkaly giriň`
  String get telefon_arkaly_giris {
    return Intl.message(
      'Telefon belgiňiz arkaly giriň',
      name: 'telefon_arkaly_giris',
      desc: '',
      args: [],
    );
  }

  /// `Dowam etmek üçin telefon belgiňizi giriziň. Size tassyklama kody bilen SMS ibereris`
  String get telefon_arkaly_giris_desc {
    return Intl.message(
      'Dowam etmek üçin telefon belgiňizi giriziň. Size tassyklama kody bilen SMS ibereris',
      name: 'telefon_arkaly_giris_desc',
      desc: '',
      args: [],
    );
  }

  /// `SMS tassyklama`
  String get sms_tassyklama {
    return Intl.message(
      'SMS tassyklama',
      name: 'sms_tassyklama',
      desc: '',
      args: [],
    );
  }

  /// `6 sanly kody şu belgä iberdik`
  String get kody_iberdik {
    return Intl.message(
      '6 sanly kody şu belgä iberdik',
      name: 'kody_iberdik',
      desc: '',
      args: [],
    );
  }

  /// `Belgini üýtget`
  String get belgini_uytget {
    return Intl.message(
      'Belgini üýtget',
      name: 'belgini_uytget',
      desc: '',
      args: [],
    );
  }

  /// `Tassyklamak`
  String get tassyklamak {
    return Intl.message('Tassyklamak', name: 'tassyklamak', desc: '', args: []);
  }

  /// `Kody gaýtadan ibermek`
  String get kody_gaytadan_ibermek {
    return Intl.message(
      'Kody gaýtadan ibermek',
      name: 'kody_gaytadan_ibermek',
      desc: '',
      args: [],
    );
  }

  /// `Maglumatlaryňyz howpsuzlyk astynda goralýar`
  String get maglumat_gorag_astynda {
    return Intl.message(
      'Maglumatlaryňyz howpsuzlyk astynda goralýar',
      name: 'maglumat_gorag_astynda',
      desc: '',
      args: [],
    );
  }

  /// `Brendler`
  String get brands {
    return Intl.message('Brendler', name: 'brands', desc: '', args: []);
  }

  /// `Brend tapylmady`
  String get brand_empty {
    return Intl.message(
      'Brend tapylmady',
      name: 'brand_empty',
      desc: '',
      args: [],
    );
  }

  /// `MBIUM Coin balansy`
  String get coin_balance_title {
    return Intl.message(
      'MBIUM Coin balansy',
      name: 'coin_balance_title',
      desc: '',
      args: [],
    );
  }

  /// `Taryhy`
  String get coin_history_tab {
    return Intl.message('Taryhy', name: 'coin_history_tab', desc: '', args: []);
  }

  /// `Doldurmalar`
  String get coin_topup_tab {
    return Intl.message(
      'Doldurmalar',
      name: 'coin_topup_tab',
      desc: '',
      args: [],
    );
  }

  /// `Balansy doldurmak`
  String get balans_doldurmak {
    return Intl.message(
      'Balansy doldurmak',
      name: 'balans_doldurmak',
      desc: '',
      args: [],
    );
  }

  /// `Möçberi (TMT)`
  String get coin_amount_tmt {
    return Intl.message(
      'Möçberi (TMT)',
      name: 'coin_amount_tmt',
      desc: '',
      args: [],
    );
  }

  /// `Kwitansiýa salgysy (URL)`
  String get coin_receipt_url {
    return Intl.message(
      'Kwitansiýa salgysy (URL)',
      name: 'coin_receipt_url',
      desc: '',
      args: [],
    );
  }

  /// `Doldurmak baradaky haýyşyňyz iberildi`
  String get coin_topup_success {
    return Intl.message(
      'Doldurmak baradaky haýyşyňyz iberildi',
      name: 'coin_topup_success',
      desc: '',
      args: [],
    );
  }

  /// `Taryh entek ýok`
  String get coin_history_empty {
    return Intl.message(
      'Taryh entek ýok',
      name: 'coin_history_empty',
      desc: '',
      args: [],
    );
  }

  /// `Doldurmalar ýok`
  String get coin_topup_empty {
    return Intl.message(
      'Doldurmalar ýok',
      name: 'coin_topup_empty',
      desc: '',
      args: [],
    );
  }

  /// `Garaşylýar`
  String get status_pending {
    return Intl.message(
      'Garaşylýar',
      name: 'status_pending',
      desc: '',
      args: [],
    );
  }

  /// `Tassyklandy`
  String get status_approved {
    return Intl.message(
      'Tassyklandy',
      name: 'status_approved',
      desc: '',
      args: [],
    );
  }

  /// `Ret edildi`
  String get status_rejected {
    return Intl.message(
      'Ret edildi',
      name: 'status_rejected',
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
