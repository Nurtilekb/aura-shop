import 'package:aurashop/core/routing/app_router.dart';
import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/user_features/basket/presentation/basket_screen.dart';
import 'package:aurashop/user_features/catalog/presentation/categories_screen.dart';
import 'package:aurashop/user_features/favorites/presentation/favorites_screen.dart';
import 'package:aurashop/user_features/home/presentation/home_screen.dart';
import 'package:aurashop/user_features/profile/presentation/profile_screen.dart';

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

            theme: state.buildTheme(Brightness.light),

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
    FavoritesScreen(),
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
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
