import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// Events
abstract class ThemeEvent {}
class ThemeToggled extends ThemeEvent {}
class ThemeSet extends ThemeEvent {
  final ThemeMode mode;
  ThemeSet(this.mode);
}

// States
abstract class ThemeState {}
class ThemeInitial extends ThemeState {
  final ThemeMode themeMode;
  ThemeInitial({this.themeMode = ThemeMode.light});
}
class ThemeLoadedState extends ThemeState {
  final ThemeMode themeMode;
  ThemeLoadedState({required this.themeMode});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeToggled>(_onThemeToggled);
    on<ThemeSet>(_onThemeSet);
  }

  void _onThemeToggled(ThemeToggled event, Emitter<ThemeState> emit) {
    final currentMode = (state is ThemeLoadedState) 
        ? (state as ThemeLoadedState).themeMode 
        : ThemeMode.light;
    
    final newMode = currentMode == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    
    emit(ThemeLoadedState(themeMode: newMode));
  }

  void _onThemeSet(ThemeSet event, Emitter<ThemeState> emit) {
    emit(ThemeLoadedState(themeMode: event.mode));
  }
}
