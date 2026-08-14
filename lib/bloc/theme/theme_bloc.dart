import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeModeStatus { light, dark, system }

class ThemeState {
  final ThemeModeStatus themeMode;
  final Color seedColor; // Для генерации общей темы (текст, фон, AppBar)
  final Color
  directAccentColor; // "Чистый" цвет для кнопок (без авто-коррекции)

  ThemeState({
    this.themeMode = ThemeModeStatus.system,
    this.seedColor = const Color(0xFF5D50FE),
    Color? directAccentColor,
  }) : directAccentColor = directAccentColor ?? const Color(0xFF5D50FE);

  ThemeState copyWith({
    ThemeModeStatus? themeMode,
    Color? seedColor,
    Color? directAccentColor,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      directAccentColor: directAccentColor ?? this.directAccentColor,
    );
  }
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  void setThemeMode(ThemeModeStatus mode) {
    emit(state.copyWith(themeMode: mode));
  }

  // Теперь устанавливаем и seed, и прямой цвет одновременно
  void setSeedColor(Color color) {
    emit(
      state.copyWith(
        seedColor: color,
        directAccentColor: color, // Сохраняем точный цвет
      ),
    );
  }

  void toggleTheme() {
    final newMode = state.themeMode == ThemeModeStatus.light
        ? ThemeModeStatus.dark
        : ThemeModeStatus.light;
    emit(state.copyWith(themeMode: newMode));
  }
}
