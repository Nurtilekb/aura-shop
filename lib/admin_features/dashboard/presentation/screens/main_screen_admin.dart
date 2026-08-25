import 'package:aurashop/admin_features/chats/presentation/screens/chats_screen.dart';
import 'package:aurashop/admin_features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:aurashop/admin_features/orders/presentation/screens/admin_orders_screen.dart';
import 'package:aurashop/admin_features/products/presentation/screens/product_screen_admin.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class Main2Screen extends StatefulWidget {
  const Main2Screen({super.key});

  @override
  State<Main2Screen> createState() => _Main2ScreenState();
}

class _Main2ScreenState extends State<Main2Screen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    DashboardScreenAdmin(),
    ProductScreenAdmin(),
    AdminOrdersScreen(),
    SupportChatsScreen(),
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
              icon: Icon(Icons.grid_view),
              label: 'Дашборд',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.view_in_ar_outlined),
              label: 'Товары',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Заказы'),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              label: 'Чаты',
            ),
          ],
        ),
      ),
    );
  }
}
