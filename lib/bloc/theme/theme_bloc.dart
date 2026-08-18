import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeModeStatus { light, dark, system }

// 1. Состояние темы
class ThemeState {
  final ThemeModeStatus themeMode;
  final Color seedColor;
  final Color directAccentColor;

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

// 2. Генерация ThemeData
extension ThemeStateX on ThemeState {
  ThemeData buildTheme(Brightness brightness) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    final customScheme = baseScheme.copyWith(
      primary: directAccentColor,
      onPrimary:
          ThemeData.estimateBrightnessForColor(directAccentColor) ==
              Brightness.dark
          ? Colors.white
          : Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: customScheme,

      // --- Настройка AppBar ---
      appBarTheme: AppBarTheme(
        backgroundColor: brightness == Brightness.light
            ? Colors.white
            : customScheme.surface,
        foregroundColor: customScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      scaffoldBackgroundColor: brightness == Brightness.light
          ? Colors.white
          : customScheme.surface,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: customScheme.primary,
          foregroundColor: customScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: customScheme.primary,
        foregroundColor: customScheme.onPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: customScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: customScheme.primary, width: 2),
        ),
      ),
    );
  }
}

// 3. Управление состоянием (Cubit)
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState());

  void setThemeMode(ThemeModeStatus mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void setSeedColor(Color color) {
    emit(state.copyWith(seedColor: color, directAccentColor: color));
  }

  void toggleTheme() {
    final newMode = state.themeMode == ThemeModeStatus.light
        ? ThemeModeStatus.dark
        : ThemeModeStatus.light;
    emit(state.copyWith(themeMode: newMode));
  }
}
