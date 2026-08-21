import 'package:aurashop/shared/models/order_model.dart';
import 'package:aurashop/shared/widgets/catalog_category_chip.dart';
import 'package:aurashop/shared/widgets/orders/empty_state_widget.dart';
import 'package:aurashop/shared/widgets/orders/order_card.dart';
import 'package:aurashop/shared/widgets/orders/orders_offline_banner.dart';
import 'package:flutter/material.dart';

enum OrdersState { empty, noInternet, success, foradmin }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, this.foradminAppbar, this.isItAdmin});

  final String? foradminAppbar;
  final bool? isItAdmin;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrdersState _currentState;

  @override
  void initState() {
    super.initState();
    _currentState = widget.isItAdmin == true
        ? OrdersState.foradmin
        : OrdersState.empty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.foradminAppbar ?? 'Мои заказы',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (_currentState) {
      case OrdersState.empty:
        return EmptyStateWidget(
          image: _buildCircleAvatar(
            backgroundColor: colorScheme.surfaceContainerHighest,
            child: const Text('📦', style: TextStyle(fontSize: 50)),
          ),
          title: 'Заказов пока нет',
          subtitle:
              'Оформленные заказы будут появляться здесь вместе со статусом доставки.',
          buttonText: 'Начать покупки',
          onPressed: () => Navigator.pop(context),
        );
      case OrdersState.noInternet:
        return Column(
          children: [
            Expanded(
              child: EmptyStateWidget(
                image: _buildCircleAvatar(
                  backgroundColor: colorScheme.primary.withValues(alpha: 0),
                  child: Icon(
                    Icons.cell_wifi,
                    size: 54,
                    color: colorScheme.error,
                  ),
                ),
                title: 'Нет соединения',
                subtitle:
                    'Не удалось загрузить данные. Проверьте интернет и повторите попытку.',
                buttonText: 'Повторить',
                buttonIcon: Icons.refresh,
                onPressed: () {},
              ),
            ),
            const OrdersOfflineBanner(),
          ],
        );
      case OrdersState.success:
        return const Center(child: Text('Список заказов'));
      case OrdersState.foradmin:
        return const MyOrders();
    }
  }

  Widget _buildCircleAvatar({
    required Color backgroundColor,
    required Widget child,
  }) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Center(child: child),
    );
  }
}

class MyOrders extends StatelessWidget {
  const MyOrders({super.key});

  static const List<OrderItem> orders = [
    OrderItem(
      id: 'ORD-001',
      status: 'Доставлен',
      date: '15.08.2026',
      total: 2450,
      items: ['Мария Кузнецова · 2 июля, 19:40'],
    ),
    OrderItem(
      id: 'ORD-002',
      status: 'В обработке',
      date: '20.08.2026',
      total: 1890,
      items: ['Игорь Петров · 3 июля, 12:05'],
    ),
    OrderItem(
      id: '#AU-24815',
      status: 'В пути',
      date: '15.08.2026',
      total: 2450,
      items: ['Анна Соколова · 3 июля, 14:20'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          if (orders.isEmpty) _buildEmptyState() else _buildOrdersList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Padding(
      padding: EdgeInsets.only(top: 100),
      child: EmptyStateWidget(
        image: CircleAvatar(
          radius: 40,
          backgroundColor: Color(0xFFE5E5EA),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 40,
            color: Color(0xFF8E8E93),
          ),
        ),
        title: 'Заказов пока нет',
        subtitle: 'Оформите первый заказ в корзине',
        buttonText: 'Перейти в корзину',
        onPressed: _noop,
      ),
    );
  }

  Widget _buildOrdersList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                CatalogCategoryChip(
                  label: 'В пути',
                  isActive: true,
                  activeColor: Colors.pink,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (int index = 0; index < orders.length; index++) ...[
            OrderCard(order: orders[index]),
            if (index < orders.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  static void _noop() {}
}
