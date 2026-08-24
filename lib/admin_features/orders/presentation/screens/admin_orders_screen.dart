import 'package:aurashop/features/profile/presentation/screens/my_orders_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrdersScreen(foradminAppbar: 'Заказы', isItAdmin: true);
  }
}
