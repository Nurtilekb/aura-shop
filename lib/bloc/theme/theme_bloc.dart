import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Состояние темы
enum ThemeModeStatus { light, dark, system }

class ThemeState {
  final ThemeModeStatus themeMode;
  final Color seedColor;

  ThemeState({
    this.themeMode = ThemeModeStatus.system,
    this.seedColor = const Color(0xFF5D50FE),
  });

  ThemeState copyWith({
    ThemeModeStatus? themeMode,
    Color? seedColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
    );
  }
}

// Кубит для управления темой
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  void setThemeMode(ThemeModeStatus mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void setSeedColor(Color color) {
    emit(state.copyWith(seedColor: color));
  }

  void toggleTheme() {
    final newMode = state.themeMode == ThemeModeStatus.light
        ? ThemeModeStatus.dark
        : ThemeModeStatus.light;
    emit(state.copyWith(themeMode: newMode));
  }
}
