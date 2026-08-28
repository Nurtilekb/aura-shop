import 'package:aurashop/bloc/orders/orders_bloc.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/models/order_model.dart';
import 'package:aurashop/shared/widgets/orders/empty_state_widget.dart';
import 'package:aurashop/shared/widgets/orders/orders_offline_banner.dart';
import 'package:aurashop/shared/widgets/orders/order_status_filter.dart';
import 'package:aurashop/shared/widgets/orders/orders_list.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, this.foradminAppbar, this.isItAdmin});
  final String? foradminAppbar;
  final bool? isItAdmin;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersBloc>().add(const LoadOrdersRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.foradminAppbar ?? 'Мои заказы',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<OrdersBloc>().add(const LoadOrdersRequested());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Обновление заказов...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: widget.isItAdmin == true ? const MyOrders() : const UserOrders(),
    );
  }
}

// Виджет для обычного пользователя
class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading || state is OrdersInitial) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Загрузка заказов...'),
              ],
            ),
          );
        }

        if (state is OrdersError) {
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
                  onPressed: () {
                    context.read<OrdersBloc>().add(const LoadOrdersRequested());
                  },
                ),
              ),
              const OrdersOfflineBanner(),
            ],
          );
        }

        if (state is OrdersLoaded) {
          final orders = state.orders;

          if (orders.isEmpty) {
            return EmptyStateWidget(
              image: _buildCircleAvatar(
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: const Text('📦', style: TextStyle(fontSize: 50)),
              ),
              title: 'Заказов пока нет',
              subtitle:
                  'Оформленные заказы будут появляться здесь вместе со статусом доставки.',
              buttonText: 'Начать покупки',
              onPressed: () => context.router.push(AllCategoriesRoute()),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrdersBloc>().add(const LoadOrdersRequested());
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Всего: ${orders.length}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          context.read<OrdersBloc>().add(
                            const LoadOrdersRequested(),
                          );
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Обновить'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: OrdersList(
                      orders: orders,
                      onStatusChanged: (order) {
                        // Для обычного пользователя статус менять нельзя
                        // Можно показать сообщение или оставить пустым
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
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

// Виджет для администратора
class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  int _selectedStatusIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersBloc>().add(const LoadAllOrdersRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading || state is OrdersInitial) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Загрузка заказов...'),
                ],
              ),
            );
          }

          if (state is OrdersError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Ошибка загрузки',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<OrdersBloc>().add(
                          const LoadOrdersRequested(),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is OrdersLoaded) {
            final orders = state.orders;

            if (orders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'У вас пока никто не заказывал',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            final filteredOrders = _filterOrdersByStatus(orders);

            if (filteredOrders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.filter_list_off,
                      size: 80,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Нет заказов с выбранным статусом',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Попробуйте выбрать другой фильтр',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedStatusIndex = 0;
                        });
                      },
                      icon: const Icon(Icons.clear),
                      label: const Text('Сбросить фильтр'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<OrdersBloc>().add(const LoadAllOrdersRequested());
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Всего: ${filteredOrders.length}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              context.read<OrdersBloc>().add(
                                const LoadAllOrdersRequested(),
                              );
                            },
                            icon: const Icon(Icons.refresh, size: 16),
                            label: const Text('Обновить'),
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      OrderStatusFilter(
                        activeColor: Theme.of(context).primaryColor,
                        selectedIndex: _selectedStatusIndex,
                        onSelected: (index) {
                          setState(() {
                            _selectedStatusIndex = index;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: OrdersList(
                          orders: filteredOrders,
                          onStatusChanged: (order) {
                            context.read<OrdersBloc>().add(
                              UpdateOrderStatusRequested(
                                orderId: order.id,
                                status: order.status,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  List<OrderItem> _filterOrdersByStatus(List<OrderItem> orders) {
    if (_selectedStatusIndex == 0) {
      return orders;
    }

    final selectedLabel = OrderStatusPalette.filterLabels[_selectedStatusIndex];
    final selectedStatusKey = OrderStatusPalette.getStatusKey(selectedLabel);

    return orders.where((order) {
      return order.status.toLowerCase() == selectedStatusKey.toLowerCase();
    }).toList();
  }
}

class OrderStatusPalette {
  static const List<String> filterLabels = [
    'Все',
    'Ожидает',
    'Подтвержден',
    'В пути',
    'Доставлен',
    'Отменен',
  ];

  static String getStatusKey(String label) {
    switch (label) {
      case 'Ожидает':
        return 'pending';
      case 'Подтвержден':
        return 'confirmed';
      case 'В пути':
        return 'shipped';
      case 'Доставлен':
        return 'delivered';
      case 'Отменен':
        return 'cancelled';
      default:
        return label.toLowerCase();
    }
  }
}
