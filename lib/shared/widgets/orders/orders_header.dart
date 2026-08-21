import 'package:flutter/material.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({
    super.key,
    required this.count,
    this.title = 'Мои заказы',
  });

  final int count;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          '$count заказов',
          style: const TextStyle(fontSize: 14, color: Color(0xFF8E8E93)),
        ),
      ],
    );
  }
}
