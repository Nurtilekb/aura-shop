import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = AutoRouter.of(context).current.name;

    final showNavBar = ['HomeRoute', 'SettingsRoute'].contains(currentRoute);

    if (!showNavBar) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context,
                    state,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Главная',
                    route: 'HomeRoute',
                    currentRoute: currentRoute,
                  ),
                  _buildNavItem(
                    context,
                    state,
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag_rounded,
                    label: 'Каталог',
                    route:
                        'HomeRoute', // Замените на CatalogRoute когда создадите
                    currentRoute: currentRoute,
                  ),
                  _buildNavItem(
                    context,
                    state,
                    icon: Icons.favorite_outline,
                    activeIcon: Icons.favorite_rounded,
                    label: 'Избранное',
                    route:
                        'HomeRoute', // Замените на FavoritesRoute когда создадите
                    currentRoute: currentRoute,
                  ),
                  _buildNavItem(
                    context,
                    state,
                    icon: Icons.person_outline,
                    activeIcon: Icons.person_rounded,
                    label: 'Профиль',
                    route: 'SettingsRoute',
                    currentRoute: currentRoute,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    ThemeState state, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required String currentRoute,
  }) {
    final isActive = currentRoute == route;
    final accentColor = state.directAccentColor;

    return InkWell(
      onTap: () {
        // if (currentRoute != route) {
        //   AutoRouter.of(context).navigateNamed('/$route');
        // }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? accentColor : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? accentColor : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
