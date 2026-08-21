import 'package:aurashop/admin_features/profile/presentation/profile_admin_screen.dart';
import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:aurashop/shared/widgets/admin/dashboard_metric_card.dart';
import 'package:aurashop/shared/widgets/admin/dashboard_order_tile.dart';
import 'package:aurashop/shared/widgets/admin/weekly_sales_card.dart';
import 'package:flutter/material.dart';

class DashboardScreenAdmin extends StatelessWidget {
  const DashboardScreenAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminProfileScreen()),
              );
            },
            child: Row(
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                    child: DashboardMetricCard(
                      title: 'Выручка · июль',
                      value: '1.24M ₽',
                      subtitle: '↑ 12.4%',
                      isPositive: true,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DashboardMetricCard(
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
                    child: DashboardMetricCard(
                      title: 'Товары',
                      value: '1 042',
                      subtitle: '24 нет в наличии',
                      isPositive: false,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: DashboardMetricCard(
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
              const WeeklySalesCard(),

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
        const DashboardOrderTile(
          id: '#24815',
          name: 'Анна С.',
          price: '10 470 ₽',
          status: 'В пути',
        ),
        const Divider(height: 1, color: Color(0xFFEFEFEF)),
        const DashboardOrderTile(
          id: '#24814',
          name: 'Игорь П.',
          price: '3 290 ₽',
          status: 'Новый',
        ),
        const Divider(height: 1, color: Color(0xFFEFEFEF)),
        const DashboardOrderTile(
          id: '#24813',
          name: 'Мария К.',
          price: '8 480 ₽',
          status: 'Готов',
        ),
      ],
    );
  }
}
