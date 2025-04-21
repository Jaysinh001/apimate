part of 'theme_bloc.dart';

enum ThemeNames { monokai, dracula, solarized, gruvbox, nord }

class ThemeState extends Equatable {
  final ThemeNames theme;
  const ThemeState({this.theme = ThemeNames.dracula});

  ThemeState copyWith({ThemeNames? theme}) =>
      ThemeState(theme: theme ?? this.theme);

  @override
  List<Object?> get props => [theme];
}
