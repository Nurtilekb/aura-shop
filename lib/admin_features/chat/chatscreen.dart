import 'package:flutter/material.dart';

class SupportChatsScreen extends StatefulWidget {
  const SupportChatsScreen({super.key});

  @override
  State<SupportChatsScreen> createState() => _SupportChatsScreenState();
}

class _SupportChatsScreenState extends State<SupportChatsScreen> {
  int _selectedFilterIndex = 0;
  int _currentBottomNavIndex = 3; // Чаты (активная вкладка)

  final List<String> _filters = ['Все', 'Открытые · 3', 'Закрытые'];

  final List<_ChatItemData> _chats = const [
    _ChatItemData(
      initials: 'АС',
      avatarBgColor: Color(0xFF5A49F8),
      isOnline: true,
      name: 'Анна Соколова',
      time: '2 мин',
      lastMessage: 'Где мой заказ #AU-24815?',
      unreadCount: 2,
    ),
    _ChatItemData(
      initials: 'ИП',
      avatarBgColor: Color(0xFF4A6FA5),
      isOnline: false,
      name: 'Игорь Петров',
      time: '18 мин',
      lastMessage: 'Можно вернуть худи, не подо...',
      unreadCount: 1,
    ),
    _ChatItemData(
      initials: 'МК',
      avatarBgColor: Color(0xFF387B5B),
      isOnline: false,
      name: 'Мария Кузнецова',
      time: '1 ч',
      lastMessage: 'Спасибо, всё пришло вовремя!',
      unreadCount: 0,
    ),
    _ChatItemData(
      initials: 'ДВ',
      avatarBgColor: Color(0xFFC25E38),
      isOnline: false,
      name: 'Дмитрий Волков',
      time: '3 ч',
      lastMessage: 'Когда будет доставка в Казань?',
      unreadCount: 1,
    ),
    _ChatItemData(
      initials: 'ОК',
      avatarBgColor: Color(0xFFE2E2DF),
      avatarTextColor: Color(0xFF6B7280),
      isOnline: false,
      name: 'Ольга Крылова',
      time: 'Вчера',
      lastMessage: 'Диалог закрыт · оценка ★★★★★',
      unreadCount: 0,
      isClosed: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5A49F8);
    const borderColor = Color(0xFFEFEFEF);
    const subtextColor = Color(0xFF8E8E93);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // 1. Заголовок и плашка "3 новых"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Чаты поддержки',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: primaryPurple,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            '3 новых',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 2. Поле поиска
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: borderColor, width: 1.5),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.search_rounded,
                            color: Color(0xFF00B2FF),
                            size: 22,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Поиск по диалогам',
                                hintStyle: TextStyle(
                                  color: subtextColor,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 3. Фильтры (Чипы)
                    Row(
                      children: List.generate(_filters.length, (index) {
                        final isSelected = _selectedFilterIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFilterIndex = index;
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF1C1C1E)
                                    : const Color(0xFFF2F1ED),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _filters[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // 4. Список чатов
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _chats.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, color: borderColor),
                      itemBuilder: (context, index) {
                        final chat = _chats[index];
                        return _ChatTile(chat: chat);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 5. Нижняя панель навигации (Bottom Navigation)
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: borderColor, width: 1.0)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _BottomNavItem(
                    icon: Icons.grid_view_rounded,
                    label: 'Дашборд',
                    isSelected: _currentBottomNavIndex == 0,
                    onTap: () => setState(() => _currentBottomNavIndex = 0),
                  ),
                  _BottomNavItem(
                    icon: Icons.widgets_outlined,
                    label: 'Товары',
                    isSelected: _currentBottomNavIndex == 1,
                    onTap: () => setState(() => _currentBottomNavIndex = 1),
                  ),
                  _BottomNavItem(
                    icon: Icons.segment_rounded,
                    label: 'Заказы',
                    isSelected: _currentBottomNavIndex == 2,
                    onTap: () => setState(() => _currentBottomNavIndex = 2),
                  ),
                  _BottomNavItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Чаты',
                    isSelected: _currentBottomNavIndex == 3,
                    onTap: () => setState(() => _currentBottomNavIndex = 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Модель данных чата
class _ChatItemData {
  final String initials;
  final Color avatarBgColor;
  final Color avatarTextColor;
  final bool isOnline;
  final String name;
  final String time;
  final String lastMessage;
  final int unreadCount;
  final bool isClosed;

  const _ChatItemData({
    required this.initials,
    required this.avatarBgColor,
    this.avatarTextColor = Colors.white,
    required this.isOnline,
    required this.name,
    required this.time,
    required this.lastMessage,
    required this.unreadCount,
    this.isClosed = false,
  });
}

/// DRY Виджет элемента списка чата
class _ChatTile extends StatelessWidget {
  final _ChatItemData chat;

  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF5A49F8);

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: Row(
          children: [
            // Аватар с индикатором
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: chat.avatarBgColor,
                  child: Text(
                    chat.initials,
                    style: TextStyle(
                      color: chat.avatarTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (chat.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Текстовый блок (Имя и Сообщение)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: chat.isClosed
                          ? const Color(0xFF8E8E93)
                          : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Время и Бейдж непрочитанных
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 6),
                if (chat.unreadCount > 0)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: primaryPurple,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Элемент нижней панели навигации
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF5A49F8);
    final inactiveColor = const Color(0xFF8E8E93);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
