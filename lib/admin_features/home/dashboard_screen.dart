import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:flutter/material.dart';

class DashboardScreenAdmin extends StatelessWidget {
  const DashboardScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconWithBack(
              sizes: 50,
              padding: const EdgeInsets.all(5),
              bordRadius: BorderRadius.circular(10),
              emoji: 'A',

              color: Colors.black,
              fontwght: FontWeight.bold,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'admin@aura.shop · Администратор',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Сетка из 4 карточек метрик (2х2)
              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: 'Выручка · июль',
                      value: '1.24M ₽',
                      subtitle: '↑ 12.4%',
                      isPositive: true,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Заказы',
                      value: '318',
                      subtitle: '↑ 8 сегодня',
                      isPositive: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _StatCard(
                      title: 'Товары',
                      value: '1 042',
                      subtitle: '24 нет в наличии',
                      isPositive: false,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Клиенты',
                      value: '5 830',
                      subtitle: '↑ 42 новых',
                      isPositive: true,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 2. Карточка графика "Продажи за неделю"
              const _WeeklySalesCard(),

              const SizedBox(height: 24),

              // 3. Секция "Последние заказы"
              const _RecentOrdersSection(),
            ],
          ),
        ),
      ),
    );
  }
}

/// DRY Виджет: Карточка метрики
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final bool isPositive;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8E8E93),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isPositive
                  ? const Color(0xFF10B981)
                  : const Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }
}

/// Виджет: График продаж за неделю
class _WeeklySalesCard extends StatelessWidget {
  const _WeeklySalesCard();

  @override
  Widget build(BuildContext context) {
    // Высоты столбцов (пропорции)
    final List<double> barHeights = [28, 48, 32, 80, 52, 40, 56];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEFEFEF), width: 1.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Продажи за неделю',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                '₽ тыс.',
                style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(barHeights.length, (index) {
                final isSelected = index == 3; // 4-й столбец выделен фиолетовым
                return Container(
                  width: 32,
                  height: barHeights[index],
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF5A49F8)
                        : const Color(0xFFF2F1ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Виджет: Список последних заказов
class _RecentOrdersSection extends StatelessWidget {
  const _RecentOrdersSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Последние заказы',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'Все',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5A49F8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _OrderItemTile(
          id: '#24815',
          name: 'Анна С.',
          price: '10 470 ₽',
          status: 'В пути',
          statusType: _StatusType.purple,
        ),
        const Divider(height: 1, color: Color(0xFFEFEFEF)),
        const _OrderItemTile(
          id: '#24814',
          name: 'Игорь П.',
          price: '3 290 ₽',
          status: 'Новый',
          statusType: _StatusType.orange,
        ),
        const Divider(height: 1, color: Color(0xFFEFEFEF)),
        const _OrderItemTile(
          id: '#24813',
          name: 'Мария К.',
          price: '8 480 ₽',
          status: 'Готов',
          statusType: _StatusType.green,
        ),
      ],
    );
  }
}

enum _StatusType { purple, orange, green }

/// DRY Виджет: Строка заказа
class _OrderItemTile extends StatelessWidget {
  final String id;
  final String name;
  final String price;
  final String status;
  final _StatusType statusType;

  const _OrderItemTile({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
    required this.statusType,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (statusType) {
      case _StatusType.purple:
        bg = const Color(0xFFE0E0FF);
        fg = const Color(0xFF5A49F8);
        break;
      case _StatusType.orange:
        bg = const Color(0xFFFFF0D6);
        fg = const Color(0xFFD97706);
        break;
      case _StatusType.green:
        bg = const Color(0xFFD3F2E4);
        fg = const Color(0xFF059669);
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Text(
            id,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
