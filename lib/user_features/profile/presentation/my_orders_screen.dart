import 'package:aurashop/shared/models/order_model.dart';
import 'package:aurashop/shared/models/order_status.dart';
import 'package:aurashop/shared/widgets/orders/empty_state_widget.dart';
import 'package:aurashop/shared/widgets/orders/orders_offline_banner.dart';
import 'package:aurashop/shared/widgets/orders/order_status_filter.dart';
import 'package:aurashop/shared/widgets/orders/orders_header.dart';
import 'package:aurashop/shared/widgets/orders/orders_list.dart';
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

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
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

  int _selectedStatusIndex = 0;

  List<OrderItem> get _filteredOrders {
    final selectedStatus =
        OrderStatusPalette.filterLabels[_selectedStatusIndex];
    if (selectedStatus == OrderStatusPalette.allLabel) {
      return orders;
    }

    return orders.where((order) => order.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [_buildOrdersContent()],
      ),
    );
  }

  Widget _buildOrdersContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrdersHeader(count: orders.length),
          const SizedBox(height: 12),
          OrderStatusFilter(
            selectedIndex: _selectedStatusIndex,
            onSelected: (index) {
              setState(() {
                _selectedStatusIndex = index;
              });
            },
          ),
          const SizedBox(height: 16),
          OrdersList(orders: _filteredOrders),
        ],
      ),
    );
  }
}
