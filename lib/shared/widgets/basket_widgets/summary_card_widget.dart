import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int? itemsCount;
  final int totalItemsPrice;
  final int discount;
  final int totalPrice;

  const SummaryCard({
    super.key,
    this.itemsCount,
    required this.totalItemsPrice,
    required this.discount,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildRow(
            'Товары ${itemsCount == null ? '' : '($itemsCount)'}',
            '$totalItemsPrice ₽',
            colorScheme,
          ),
          const SizedBox(height: 8),
          _buildRow(
            'Скидка',
            '-$discount ₽',
            colorScheme,
            valueColor: const Color(0xFF00A86B),
          ),
          const SizedBox(height: 8),
          _buildRow('Доставка', 'Бесплатно', colorScheme),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 0.5),
          ),
          _buildRow('Итого', '$totalPrice ₽', colorScheme, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value,
    ColorScheme colorScheme, {
    Color? valueColor,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? colorScheme.onSurface : colorScheme.outline,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
