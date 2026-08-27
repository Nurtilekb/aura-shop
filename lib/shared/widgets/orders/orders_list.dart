import 'package:aurashop/shared/models/order_model.dart';
import 'package:aurashop/shared/widgets/orders/empty_state_widget.dart';
import 'package:aurashop/shared/widgets/orders/order_card.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({
    super.key,
    required this.orders,
    this.title = 'Мои заказы',
    this.emptyTitle = 'Заказов пока нет',
    this.emptySubtitle = 'Оформите первый заказ в корзине',
    this.emptyButtonText = 'Перейти в корзину',
    this.onEmptyPressed,
    this.onStatusChanged,
  });

  final List<OrderItem> orders;
  final String title;
  final String emptyTitle;
  final String emptySubtitle;
  final String emptyButtonText;
  final VoidCallback? onEmptyPressed;
  final ValueChanged<OrderItem>? onStatusChanged;
  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: EmptyStateWidget(
          image: const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFE5E5EA),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 40,
              color: Color(0xFF8E8E93),
            ),
          ),
          title: emptyTitle,
          subtitle: emptySubtitle,
          buttonText: emptyButtonText,
          onPressed: onEmptyPressed ?? _noop,
        ),
      );
    }

    return Column(
      children: [
        for (int index = 0; index < orders.length; index++)
          Padding(
            padding: EdgeInsets.only(
              bottom: index < orders.length - 1 ? 10 : 0,
            ),
            child: OrderCard(
              order: orders[index],
              onStatusChanged: onStatusChanged == null
                  ? null
                  : (status) => onStatusChanged!(
                      orders[index].copyWith(status: status),
                    ),
            ),
          ),
      ],
    );
  }

  static void _noop() {}
}
