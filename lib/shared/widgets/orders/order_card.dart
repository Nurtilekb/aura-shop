import 'package:aurashop/shared/models/order_model.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final OrderItem order;

  Color _statusColor(String status) {
    switch (status) {
      case 'Доставлен':
        return const Color(0xFF34C759);
      case 'В пути':
        return const Color(0xFFFF9500);
      case 'Новый':
        return const Color(0xFF007AFF);
      case 'Отменён':
        return const Color(0xFFFF3B30);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(width: 0.6, color: Colors.grey),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.id,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  Text(
                    '${order.total} ₽',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                order.items.join(' • '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFE5E5EA), height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Статус:',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: const Color(0xFFE5E5EA),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                order.status,
                                style: TextStyle(
                                  color: _statusColor(order.status),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
