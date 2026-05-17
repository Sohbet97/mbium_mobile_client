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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
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
