import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  const OrderItem({
    required this.id,
    required this.status,
    required this.date,
    required this.total,
    required this.items,
  });

  final String id;
  final String status;
  final String date;
  final int total;
  final List<String> items;

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'] as List<dynamic>? ?? [];

    return OrderItem(
      id: map['id']?.toString() ?? '',
      status: _convertStatus(map['status']?.toString()),
      date: _convertDate(map['createdAt']),
      total: (map['totalAmount'] as num?)?.toInt() ?? 0,
      items: rawItems.map((item) {
        if (item is String) return item;

        if (item is Map) {
          return item['name']?.toString() ??
              item['title']?.toString() ??
              'Товар';
        }

        return item.toString();
      }).toList(),
    );
  }

  static String _convertStatus(String? status) {
    switch (status) {
      case 'pending':
        return 'Новый';
      case 'processing':
        return 'В обработке';
      case 'shipped':
        return 'В пути';
      case 'delivered':
        return 'Доставлен';
      case 'cancelled':
        return 'Отменён';
      default:
        return status ?? 'Новый';
    }
  }

  static String _convertDate(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();

      return '${date.day.toString().padLeft(2, '0')}.'
          '${date.month.toString().padLeft(2, '0')}.'
          '${date.year}';
    }

    return value?.toString() ?? '';
  }

  OrderItem copyWith({String? status}) {
    return OrderItem(
      id: id,
      status: status ?? this.status,
      date: date,
      total: total,
      items: items,
    );
  }
}
