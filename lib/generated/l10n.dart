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

  /// `Üpjünçilerden has takyk söwda tekliplerini almak üçin...`
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

  /// `Ý götow(a) предоставить свою визитку поставщикам...`
  String get rfq_checkbox1 {
    return Intl.message(
      'Я готов(a) предоставить свою визитку поставщикам, опубликовавшим свои ценовые предложения.',
      name: 'rfq_checkbox1',
      desc: '',
      args: [],
    );
  }

  /// `Я прочитал(а), понял(а) и соглашаюсь...`
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

  String get unit_sany {
    return Intl.message('sany', name: 'unit_sany', desc: '', args: []);
  }

  String get unit_kg {
    return Intl.message('kg', name: 'unit_kg', desc: '', args: []);
  }

  String get unit_litr {
    return Intl.message('litr', name: 'unit_litr', desc: '', args: []);
  }

  String get unit_m {
    return Intl.message('m', name: 'unit_m', desc: '', args: []);
  }

  String get unit_sm {
    return Intl.message('sm', name: 'unit_sm', desc: '', args: []);
  }

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
