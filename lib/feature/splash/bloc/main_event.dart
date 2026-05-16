part of 'main_bloc.dart';

@immutable
sealed class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object> get props => [];
}

final class MainInitial extends MainEvent {
  const MainInitial();

  @override
  List<Object> get props => [];
}

final class ChangeLanguage extends MainEvent {
  final String languageCode;

  const ChangeLanguage({required this.languageCode});

  @override
  List<Object> get props => [languageCode];
}

final class ChangeTheme extends MainEvent {
  final ThemeMode themeMode;

  const ChangeTheme({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

final class SetNavigationPageEvent extends MainEvent {
  final int index;

  const SetNavigationPageEvent({required this.index});

  @override
  List<Object> get props => [index];
}
