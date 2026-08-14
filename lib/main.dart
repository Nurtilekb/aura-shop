import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/router/app_router.dart';
import 'package:aurashop/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final brightness = MediaQuery.platformBrightnessOf(context);
          final isDarkMode = state.themeMode == ThemeModeStatus.dark ||
              (state.themeMode == ThemeModeStatus.system && brightness == Brightness.dark);
          
          final appColors = isDarkMode
              ? AppColors.dark(state.seedColor)
              : AppColors.light(state.seedColor);

          return MaterialApp.router(
            title: 'AuraShop',
            theme: appColors.toThemeData(),
            routerConfig: AppRouter().config(),
          );
        },
      ),
    );
  }
}
