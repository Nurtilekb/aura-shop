import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/router/app_router.dart';
import 'package:aurashop/screens/basket/basket_screen.dart';
import 'package:aurashop/screens/catalog/categories_screen.dart';
import 'package:aurashop/screens/home/home_screen.dart';
import 'package:aurashop/screens/profile/progile_screen.dart';
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
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'AuraShop',

            // 1. Передаем динамические темы из нашего расширения ThemeStateX
            theme: state.buildTheme(Brightness.light),
            darkTheme: state.buildTheme(Brightness.dark),
            themeMode: switch (state.themeMode) {
              ThemeModeStatus.light => ThemeMode.light,
              ThemeModeStatus.dark => ThemeMode.dark,
              ThemeModeStatus.system => ThemeMode.system,
            },

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
    HomeScreen(),
    AllCategories(),
    CartScreen(),
    const SizedBox.shrink(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 6),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: colorScheme.surface,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,

          selectedItemColor: colorScheme.primary,

          unselectedItemColor: colorScheme.onSurfaceVariant,

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
