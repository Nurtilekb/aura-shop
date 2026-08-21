import 'package:flutter/material.dart';

class ChipList extends StatelessWidget {
  const ChipList({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
    this.activeColor = const Color(0xFF1C1C1E),
    this.inactiveColor = const Color(0xFFF2F1ED),
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = Colors.black,
    this.spacing = 8,
    this.horizontalPadding = 18,
    this.verticalPadding = 10,
    this.height = 40,
    this.borderColor,
    this.contentPadding = EdgeInsets.zero,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;
  final double spacing;
  final double horizontalPadding;
  final double verticalPadding;
  final double height;
  final Color? borderColor;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: horizontalPadding),
      child: SizedBox(
        height: height,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: contentPadding,
          itemCount: labels.length,
          separatorBuilder: (_, _) => SizedBox(width: spacing),
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;

            return InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: borderColor != null ? 0.5 : 0,
                    color: borderColor ?? Colors.transparent,
                  ),
                  color: isSelected ? activeColor : inactiveColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? activeTextColor : inactiveTextColor,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
