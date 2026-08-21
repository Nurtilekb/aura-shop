import 'package:aurashop/features/profile/presentation/screens/my_orders_screen.dart';
import 'package:flutter/material.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrdersScreen(foradminAppbar: 'Заказы', isItAdmin: true);
  }
}
