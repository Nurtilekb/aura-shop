import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:aurashop/shared/widgets/admin/dashboard_metric_card.dart';
import 'package:aurashop/shared/widgets/admin/dashboard_order_tile.dart';
import 'package:aurashop/shared/widgets/admin/weekly_sales_card.dart';
import 'package:aurashop/repositories/product_repository.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@RoutePage()
class DashboardScreenAdmin extends StatefulWidget {
  const DashboardScreenAdmin({super.key});

  @override
  State<DashboardScreenAdmin> createState() => _DashboardScreenAdminState();
}

class _DashboardScreenAdminState extends State<DashboardScreenAdmin> {
  final ProductRepository _productRepository = ProductRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // analytics are driven by streams in UI

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.router.push(AdminProfileRoute(name: user));
            },
            child: Row(
              children: [
                IconWithBack(
                  sizes: 50,
                  padding: const EdgeInsets.all(5),
                  bordRadius: BorderRadius.circular(10),
                  emoji: user.displayName?[0],

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
                      '${user.displayName} · Администратор',
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

              // 3. Секция аналитики по категориям
              _buildCategoryAnalyticsSection(),

              const SizedBox(height: 24),

              // 4. Секция "Последние заказы"
              const _RecentOrdersSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryAnalyticsSection() {
    return StreamBuilder<List<Product>>(
      stream: _productRepository.watchProducts(),
      builder: (context, prodSnap) {
        final products = prodSnap.data ?? const [];
        final prodById = {for (var p in products) p.id: p};

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('orders')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, orderSnap) {
            if (orderSnap.connectionState == ConnectionState.waiting &&
                prodSnap.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final stats = <String, CategoryStats>{};

            final docs = orderSnap.data?.docs ?? [];
            for (final doc in docs) {
              final data = doc.data();
              final items = (data['items'] as List<dynamic>?) ?? [];

              for (final rawItem in items) {
                String category = 'Без категории';
                double price = 0.0;
                int quantity = 1;

                if (rawItem is Map) {
                  final pid = rawItem['productId']?.toString();
                  price = (rawItem['price'] is num)
                      ? (rawItem['price'] as num).toDouble()
                      : double.tryParse(rawItem['price']?.toString() ?? '0') ??
                            0.0;
                  quantity = rawItem['quantity'] is num
                      ? (rawItem['quantity'] as num).toInt()
                      : int.tryParse(rawItem['quantity']?.toString() ?? '1') ??
                            1;

                  if (pid != null &&
                      pid.isNotEmpty &&
                      prodById.containsKey(pid)) {
                    category = prodById[pid]!.category;
                  }
                } else if (rawItem is String) {
                  final found = prodById.values.firstWhere(
                    (p) => p.name.toLowerCase() == rawItem.toLowerCase(),
                    orElse: () => Product(
                      id: '',
                      name: '',
                      price: 0,
                      category: 'Без категории',
                      description: '',
                    ),
                  );
                  category = found.category;
                }

                final cur =
                    stats[category] ?? CategoryStats(category: category);
                cur.itemsCount += quantity;
                cur.revenue += (price * quantity).round();
                stats[category] = cur;
              }
            }

            if (stats.isEmpty) {
              return const Text(
                'Нет данных для отображения',
                style: TextStyle(color: Colors.black54),
              );
            }

            final entries = stats.values.toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Аналитика по категориям',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: entries.map((c) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        c.category,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${c.itemsCount} товаров · ${c.revenue} ₽',
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
              ],
            );
          },
        );
      },
    );
  }
}

class CategoryStats {
  final String category;
  int itemsCount;
  int revenue;

  CategoryStats({
    required this.category,
    this.itemsCount = 0,
    this.revenue = 0,
  });
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
