import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../generated/l10n.dart';

const List<LocalizationsDelegate<dynamic>> appLocalizationDelegates = [
  S.delegate,
  AppMaterialLocalizationsDelegate.delegate,
  AppWidgetsLocalizationsDelegate.delegate,
  AppCupertinoLocalizationsDelegate.delegate,
];

class AppMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const AppMaterialLocalizationsDelegate();

  static const delegate = AppMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return switch (locale.languageCode) {
      'ru' || 'tk' || 'en' => true,
      _ => false,
    };
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return GlobalMaterialLocalizations.delegate.load(_fallbackLocale(locale));
  }

  @override
  bool shouldReload(AppMaterialLocalizationsDelegate old) => false;
}

class AppWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const AppWidgetsLocalizationsDelegate();

  static const delegate = AppWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return switch (locale.languageCode) {
      'ru' || 'tk' || 'en' => true,
      _ => false,
    };
  }

  @override
  Future<WidgetsLocalizations> load(Locale locale) {
    return GlobalWidgetsLocalizations.delegate.load(_fallbackLocale(locale));
  }

  @override
  bool shouldReload(AppWidgetsLocalizationsDelegate old) => false;
}

class AppCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const AppCupertinoLocalizationsDelegate();

  static const delegate = AppCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return switch (locale.languageCode) {
      'ru' || 'tk' || 'en' => true,
      _ => false,
    };
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return GlobalCupertinoLocalizations.delegate.load(_fallbackLocale(locale));
  }

  @override
  bool shouldReload(AppCupertinoLocalizationsDelegate old) => false;
}

Locale _fallbackLocale(Locale locale) {
  if (locale.languageCode == 'tk') {
    return const Locale('ru');
  }

  return locale;
}
