part of 'theme_bloc.dart';

class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTheme extends ThemeEvent {
  final ThemeNames theme;

  const ChangeTheme({required this.theme});

  @override
  List<Object?> get props => [theme];
}
