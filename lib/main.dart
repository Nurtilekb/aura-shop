import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/router/app_router.dart';
import 'package:aurashop/screens/home/home_screen.dart';
import 'package:aurashop/screens/settings/progile_screen.dart';
import 'package:aurashop/screens/settings/settings_screen.dart';
import 'package:aurashop/theme/app_colors.dart';
import 'package:auto_route/auto_route.dart';
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

          final isDarkMode =
              state.themeMode == ThemeModeStatus.dark ||
              (state.themeMode == ThemeModeStatus.system &&
                  brightness == Brightness.dark);

          final appColors = isDarkMode
              ? AppColors.dark(state.seedColor)
              : AppColors.light(state.seedColor);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'AuraShop',
            theme: appColors.toThemeData(),
            routerConfig: AppRouter().config(),
          );
        },
      ),
    );
  }
}

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 6),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(137, 158, 158, 158),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.purple.shade700,
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Главная',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Каталог',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.delete_outline_outlined),
              label: 'Корзина',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: 'Избранное',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_4_outlined),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
