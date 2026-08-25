import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key, this.name});
  final User? name;

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  bool _manageProducts = true;
  bool _processOrders = true;
  bool _manageUsers = false;

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5A49F8);
    const borderColor = Color(0xFFEFEFEF);
    const subtextColor = Color(0xFF8E8E93);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Админ ',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 23,
            fontWeight: FontWeight(600),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconWithBack(
                backroundcolor: Colors.black,
                emoji: widget.name?.displayName?[0],
                emojiSizes: 40,
                color: Theme.of(context).colorScheme.onPrimary,
                fontwght: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              Text(
                widget.name?.displayName ?? 'User',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.name!.email ?? "admin@email.com",
                style: TextStyle(
                  fontSize: 14,
                  color: subtextColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: primaryPurple.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.shield_outlined, size: 16, color: primaryPurple),
                    SizedBox(width: 6),
                    Text(
                      'Роль: Администратор',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: primaryPurple,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const _SectionHeader(title: 'ПРАВА ДОСТУПА'),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Column(
                  children: [
                    _PermissionSwitchRow(
                      title: 'Управление товарами',
                      value: _manageProducts,
                      onChanged: (val) => setState(() => _manageProducts = val),
                    ),
                    const Divider(height: 1, color: borderColor),
                    _PermissionSwitchRow(
                      title: 'Обработка заказов',
                      value: _processOrders,
                      onChanged: (val) => setState(() => _processOrders = val),
                    ),
                    const Divider(height: 1, color: borderColor),
                    _PermissionSwitchRow(
                      title: 'Управление пользователями',
                      value: _manageUsers,
                      onChanged: (val) => setState(() => _manageUsers = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _SectionHeader(title: 'УПРАВЛЕНИЕ'),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Column(
                  children: [
                    _ManagementTile(
                      icon: Icons.people_alt_rounded,
                      iconColor: primaryPurple,
                      title: 'Команда и роли',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: borderColor),
                    _ManagementTile(
                      icon: Icons.bar_chart_rounded,
                      iconColor: const Color(0xFF10B981),
                      title: 'Отчёты',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: borderColor),
                    _ManagementTile(
                      icon: Icons.settings_outlined,
                      iconColor: const Color(0xFF6B7280),
                      title: 'Настройки магазина',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: borderColor),
                    _ManagementTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: primaryPurple,
                      title: 'Чат поддержки\nклиентов',
                      badgeText: '3 новых',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: borderColor, width: 1.5),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Выйти из панели',
                    style: TextStyle(
                      color: Color(0xFFE53E3E),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9CA3AF),
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}

class _PermissionSwitchRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PermissionSwitchRow({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: const Color(0xFF5A49F8),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ManagementTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? badgeText;
  final VoidCallback onTap;

  const _ManagementTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.badgeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
            ),
            if (badgeText != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD97706),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
