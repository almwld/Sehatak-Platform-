import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();
  @override List<Object?> get props => [];
}

class ThemeLight extends ThemeState {}
class ThemeDark extends ThemeState {}

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  @override List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent {}
class SetLightTheme extends ThemeEvent {}
class SetDarkTheme extends ThemeEvent {}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeLight()) {
    on<ToggleTheme>((event, emit) {
      if (state is ThemeLight) {
        emit(ThemeDark());
      } else {
        emit(ThemeLight());
      }
    });
    on<SetLightTheme>((event, emit) => emit(ThemeLight()));
    on<SetDarkTheme>((event, emit) => emit(ThemeDark()));
  }
}
