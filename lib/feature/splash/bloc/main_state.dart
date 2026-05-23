part of 'main_bloc.dart';

final class MainState extends Equatable {
  final ThemeMode themeMode;
  final String languageCode;
  final int navigationIndex;

  const MainState({
    this.themeMode = ThemeMode.light,
    this.languageCode = 'ru',
    this.navigationIndex = 0,
  });

  MainState copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    int? navigationIndex,
  }) {
    return MainState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      navigationIndex: navigationIndex ?? this.navigationIndex,
    );
  }

  @override
  List<Object> get props => [themeMode, languageCode, navigationIndex];
}
