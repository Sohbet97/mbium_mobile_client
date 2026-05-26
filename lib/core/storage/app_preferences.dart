import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _themeModeKey = 'theme_mode';
  static const _languageCodeKey = 'language_code';
  static const _registerKey = 'is_registered';
  static const _isGosth = "is_gost";

  final SharedPreferences _sharedPreferences;

  AppPreferences._(this._sharedPreferences);

  Future<void> clearAll() async {
    _sharedPreferences.clear();
  }

  static Future<AppPreferences> create() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return AppPreferences._(sharedPreferences);
  }

  ThemeMode readThemeMode() {
    final savedThemeMode = _sharedPreferences.getString(_themeModeKey);

    return switch (savedThemeMode) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.system,
    };
  }

  String? readLanguageCode() {
    return _sharedPreferences.getString(_languageCodeKey);
  }

  Future<void> saveThemeMode(ThemeMode themeMode) {
    return _sharedPreferences.setString(_themeModeKey, themeMode.name);
  }

  Future<void> saveLanguageCode(String languageCode) {
    return _sharedPreferences.setString(_languageCodeKey, languageCode);
  }

  Future<void> saveRegistrationStatus(bool isRegistered) {
    return _sharedPreferences.setBool(_registerKey, isRegistered);
  }

  Future<bool> isRegistered() async {
    return _sharedPreferences.getBool(_registerKey) ?? false;
  }

  Future<bool> isGostUser() async {
    return _sharedPreferences.getBool(_isGosth) ?? false;
  }

  Future<void> saveGostUser(bool status) {
    return _sharedPreferences.setBool(_isGosth, status);
  }

  String? getString(String key) => _sharedPreferences.getString(key);

  Future<bool> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);
}
