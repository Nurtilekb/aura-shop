import 'package:flutter/material.dart';

class AppColors {
  final Color seedColor;
  
  // Основные цвета
  late final Color primary;
  late final Color onPrimary;
  late final Color primaryContainer;
  late final Color onPrimaryContainer;
  
  // Вторичные цвета
  late final Color secondary;
  late final Color onSecondary;
  late final Color secondaryContainer;
  late final Color onSecondaryContainer;
  
  // Третичные цвета
  late final Color tertiary;
  late final Color onTertiary;
  late final Color tertiaryContainer;
  late final Color onTertiaryContainer;
  
  // Цвета ошибок
  late final Color error;
  late final Color onError;
  late final Color errorContainer;
  late final Color onErrorContainer;
  
  // Цвета фона и поверхности
  late final Color background;
  late final Color onBackground;
  late final Color surface;
  late final Color onSurface;
  late final Color surfaceVariant;
  late final Color onSurfaceVariant;
  late final Color outline;
  late final Color outlineVariant;
  
  // Дополнительные цвета
  late final Color inverseSurface;
  late final Color onInverseSurface;
  late final Color inversePrimary;
  late final Color shadow;
  late final Color surfaceTint;

  AppColors.light(this.seedColor) {
    _generateLightColors();
  }

  AppColors.dark(this.seedColor) {
    _generateDarkColors();
  }

  void _generateLightColors() {
    // Генерация цветовой схемы на основе seedColor
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );

    primary = colorScheme.primary;
    onPrimary = colorScheme.onPrimary;
    primaryContainer = colorScheme.primaryContainer;
    onPrimaryContainer = colorScheme.onPrimaryContainer;
    
    secondary = colorScheme.secondary;
    onSecondary = colorScheme.onSecondary;
    secondaryContainer = colorScheme.secondaryContainer;
    onSecondaryContainer = colorScheme.onSecondaryContainer;
    
    tertiary = colorScheme.tertiary;
    onTertiary = colorScheme.onTertiary;
    tertiaryContainer = colorScheme.tertiaryContainer;
    onTertiaryContainer = colorScheme.onTertiaryContainer;
    
    error = colorScheme.error;
    onError = colorScheme.onError;
    errorContainer = colorScheme.errorContainer;
    onErrorContainer = colorScheme.onErrorContainer;
    
    background = colorScheme.background;
    onBackground = colorScheme.onBackground;
    surface = colorScheme.surface;
    onSurface = colorScheme.onSurface;
    surfaceVariant = colorScheme.surfaceVariant;
    onSurfaceVariant = colorScheme.onSurfaceVariant;
    outline = colorScheme.outline;
    outlineVariant = colorScheme.outlineVariant;
    
    inverseSurface = colorScheme.inverseSurface;
    onInverseSurface = colorScheme.onInverseSurface;
    inversePrimary = colorScheme.inversePrimary;
    shadow = colorScheme.shadow;
    surfaceTint = colorScheme.surfaceTint;
  }

  void _generateDarkColors() {
    // Генерация цветовой схемы на основе seedColor
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    primary = colorScheme.primary;
    onPrimary = colorScheme.onPrimary;
    primaryContainer = colorScheme.primaryContainer;
    onPrimaryContainer = colorScheme.onPrimaryContainer;
    
    secondary = colorScheme.secondary;
    onSecondary = colorScheme.onSecondary;
    secondaryContainer = colorScheme.secondaryContainer;
    onSecondaryContainer = colorScheme.onSecondaryContainer;
    
    tertiary = colorScheme.tertiary;
    onTertiary = colorScheme.onTertiary;
    tertiaryContainer = colorScheme.tertiaryContainer;
    onTertiaryContainer = colorScheme.onTertiaryContainer;
    
    error = colorScheme.error;
    onError = colorScheme.onError;
    errorContainer = colorScheme.errorContainer;
    onErrorContainer = colorScheme.onErrorContainer;
    
    background = colorScheme.background;
    onBackground = colorScheme.onBackground;
    surface = colorScheme.surface;
    onSurface = colorScheme.onSurface;
    surfaceVariant = colorScheme.surfaceVariant;
    onSurfaceVariant = colorScheme.onSurfaceVariant;
    outline = colorScheme.outline;
    outlineVariant = colorScheme.outlineVariant;
    
    inverseSurface = colorScheme.inverseSurface;
    onInverseSurface = colorScheme.onInverseSurface;
    inversePrimary = colorScheme.inversePrimary;
    shadow = colorScheme.shadow;
    surfaceTint = colorScheme.surfaceTint;
  }

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: primary == Colors.white ? Brightness.dark : Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        titleTextStyle: TextStyle(
          color: onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        hintStyle: TextStyle(color: outline),
        labelStyle: TextStyle(color: onSurfaceVariant),
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 2,
        shadowColor: shadow,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: onSurface, fontSize: 57, fontWeight: FontWeight.w400),
        displayMedium: TextStyle(color: onSurface, fontSize: 45, fontWeight: FontWeight.w400),
        displaySmall: TextStyle(color: onSurface, fontSize: 36, fontWeight: FontWeight.w400),
        headlineLarge: TextStyle(color: onSurface, fontSize: 32, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(color: onSurface, fontSize: 28, fontWeight: FontWeight.w400),
        headlineSmall: TextStyle(color: onSurface, fontSize: 24, fontWeight: FontWeight.w400),
        titleLarge: TextStyle(color: onSurface, fontSize: 22, fontWeight: FontWeight.w500),
        titleMedium: TextStyle(color: onSurface, fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: onSurface, fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: onSurface, fontSize: 16, fontWeight: FontWeight.w400),
        bodyMedium: TextStyle(color: onSurface, fontSize: 14, fontWeight: FontWeight.w400),
        bodySmall: TextStyle(color: onSurface, fontSize: 12, fontWeight: FontWeight.w400),
        labelLarge: TextStyle(color: onSurface, fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(color: onSurface, fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(color: onSurface, fontSize: 11, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Метод для копирования с новым seed цветом
  AppColors copyWith({Color? seedColor}) {
    final newSeedColor = seedColor ?? this.seedColor;
    if (primary == Colors.white) {
      return AppColors.dark(newSeedColor);
    } else {
      return AppColors.light(newSeedColor);
    }
  }
}
