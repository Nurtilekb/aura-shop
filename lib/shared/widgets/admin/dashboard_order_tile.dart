import 'package:aurashop/shared/models/order_status.dart';
import 'package:flutter/material.dart';

class DashboardOrderTile extends StatelessWidget {
  const DashboardOrderTile({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.status,
  });

  final String id;
  final String name;
  final String price;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            id,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: OrderStatusPalette.backgroundColor(status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: OrderStatusPalette.textColor(status),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
