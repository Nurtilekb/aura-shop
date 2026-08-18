import 'package:aurashop/screens/settings/settings_screen.dart';
import 'package:aurashop/widgets/pressed_button.dart';
import 'package:aurashop/widgets/profile_widgets/menu_item.dart';
import 'package:aurashop/widgets/profile_widgets/stat_card_widget.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            children: [
              const _UserProfileHeader(
                name: 'Анна Соколова',
                email: 'anna@mail.ru',
                initials: 'АС',
              ),
              const SizedBox(height: 24),
              const Row(
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
              const SizedBox(height: 24),

              // Список пунктов меню
              MenuItem(emaji: '📦', title: 'Мои заказы', onTap: () {}),
              MenuItem(emaji: '♡', title: 'Избранное', onTap: () {}),
              MenuItem(emaji: '📍', title: 'Мои адреса', onTap: () {}),
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
                onTap: () {},
              ),
              const SizedBox(height: 24),
              SizedBox(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String initials;

  const _UserProfileHeader({
    required this.name,
    required this.email,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 46,
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
            onPressed: () {},
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
