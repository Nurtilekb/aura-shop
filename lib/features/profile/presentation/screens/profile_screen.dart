import 'package:aurashop/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:aurashop/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:aurashop/features/profile/presentation/screens/my_adresses_screen.dart';
import 'package:aurashop/features/profile/presentation/screens/my_orders_screen.dart';
import 'package:aurashop/features/profile/presentation/screens/settings_screen.dart';
import 'package:aurashop/features/profile/presentation/screens/support_chat_screen.dart';
import 'package:aurashop/shared/widgets/custom_widgets/pressed_button.dart';
import 'package:aurashop/shared/widgets/profile_widgets/menu_item.dart';
import 'package:aurashop/shared/widgets/profile_widgets/stat_card_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 4,
                ),
                child: const UserProfileHeader(
                  name: 'Анна Соколова',
                  email: 'anna@mail.ru',
                  initials: 'АС',
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 4,
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: StatCard(value: '12', label: 'Заказов'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatCard(value: '6', label: 'Избранное'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: StatCard(value: '340', label: 'Бонусы'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MenuItem(
                emaji: '📦',
                title: 'Мои заказы',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersScreen()),
                  );
                },
              ),
              MenuItem(
                emaji: '♡',
                title: 'Избранное',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FavoritesScreen()),
                  );
                },
              ),
              MenuItem(
                emaji: '📍',
                title: 'Мои адреса',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyAdressesScreen()),
                  );
                },
              ),
              MenuItem(
                emaji: '⚙',
                title: 'Настройки',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              MenuItem(
                emaji: '💬',
                title: 'Поддержка',
                badgeText: 'Онлайн',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupportChatScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 4,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: PressedButton(
                    height: 60,
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    borderColor: Colors.grey,
                    text: 'Выйти',
                    textstyle: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String initials;

  const UserProfileHeader({
    required this.name,
    required this.email,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFF6C5CE7),
          child: Text(
            initials,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 29,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen()),
              );
            },
            icon: const Icon(Icons.edit_outlined, size: 20),
            color: Colors.grey.shade700,
            style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }
}
