import 'package:aurashop/shared/models/order_status.dart';
import 'package:aurashop/shared/widgets/chip_list.dart';
import 'package:flutter/material.dart';

class OrderStatusFilter extends StatelessWidget {
  const OrderStatusFilter({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    this.activeColor = Colors.pink,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return ChipList(
      labels: OrderStatusPalette.filterLabels,
      selectedIndex: selectedIndex,
      activeColor: activeColor,
      inactiveColor: Colors.white,
      inactiveTextColor: Colors.grey.shade700,
      spacing: 8,
      onSelected: onSelected,
    );
  }
}
