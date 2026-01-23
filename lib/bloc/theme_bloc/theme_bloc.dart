import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ChangeTheme>(handleChangeTheme);
  }

  FutureOr<void> handleChangeTheme(
    ChangeTheme event,
    Emitter<ThemeState> emit,
  ) {
    emit(state.copyWith(theme: event.theme));
  }
}
