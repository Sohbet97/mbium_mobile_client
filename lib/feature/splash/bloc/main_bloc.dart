import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../../../core/constants/app_locales.dart';
import '../../../core/storage/app_preferences.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final Dio dio;
  final AppPreferences appPreferences;

  MainBloc({required this.dio, required this.appPreferences})
    : super(const MainState()) {
    on<MainInitial>(_onMainInitial);
    on<ChangeLanguage>(_onChangeLanguage);
    on<ChangeTheme>(_onChangeTheme);
    on<SetNavigationPageEvent>(_onSetNavigationPage);
  }

  Future<void> _onMainInitial(
    MainInitial event,
    Emitter<MainState> emit,
  ) async {
    emit(
      state.copyWith(
        themeMode: appPreferences.readThemeMode(),
        languageCode: _resolveLanguageCode(appPreferences.readLanguageCode()),
      ),
    );
  }

  Future<void> _onChangeLanguage(
    ChangeLanguage event,
    Emitter<MainState> emit,
  ) async {
    final languageCode = _resolveLanguageCode(event.languageCode);
    await appPreferences.saveLanguageCode(languageCode);
    emit(state.copyWith(languageCode: languageCode));
  }

  Future<void> _onChangeTheme(
    ChangeTheme event,
    Emitter<MainState> emit,
  ) async {
    await appPreferences.saveThemeMode(event.themeMode);
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onSetNavigationPage(
    SetNavigationPageEvent event,
    Emitter<MainState> emit,
  ) {
    emit(state.copyWith(navigationIndex: event.index));
  }

  String _resolveLanguageCode(String? savedLanguageCode) {
    final normalizedSavedLanguageCode = switch (savedLanguageCode) {
      'tm' => 'tk',
      _ => savedLanguageCode,
    };

    if (normalizedSavedLanguageCode != null &&
        appSupportedLanguageCodes.contains(normalizedSavedLanguageCode)) {
      return normalizedSavedLanguageCode;
    }

    final systemLanguageCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    if (appSupportedLanguageCodes.contains(systemLanguageCode)) {
      return systemLanguageCode;
    }

    return appSupportedLocales.first.languageCode;
  }
}
