import 'package:flutter/material.dart';

class OrderStatusPalette {
  const OrderStatusPalette._();

  static const allLabel = 'Все';

  static const labels = [
    'Новый',
    'В обработке',
    'В пути',
    'Доставлен',
    'Отменён',
  ];

  static const filterLabels = [
    allLabel,
    'В пути',
    'В обработке',
    'Доставлен',
    'Отменён',
  ];

  static Color textColor(String status) {
    switch (status) {
      case 'Доставлен':
      case 'Готов':
        return const Color(0xFF059669);
      case 'В пути':
        return const Color(0xFFD97706);
      case 'Новый':
        return const Color(0xFF007AFF);
      case 'Отменён':
        return const Color(0xFFFF3B30);
      case 'В обработке':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF8E8E93);
    }
  }

  static Color backgroundColor(String status) {
    switch (status) {
      case 'Доставлен':
      case 'Готов':
        return const Color(0xFFD3F2E4);
      case 'В пути':
        return const Color(0xFFFFF0D6);
      case 'Новый':
        return const Color(0xFFE0E0FF);
      case 'Отменён':
        return const Color(0xFFFFE1E1);
      case 'В обработке':
        return const Color(0xFFFFF0D6);
      default:
        return const Color(0xFFF2F1ED);
    }
  }
}
