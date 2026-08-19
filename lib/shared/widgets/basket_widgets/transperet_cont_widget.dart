import 'package:flutter/material.dart';

class TransperetContWidget extends StatelessWidget {
  const TransperetContWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.isIncenterWidget,
    this.leadWidget,
  });
  final String label;
  final String value;
  final String icon;
  final Widget? isIncenterWidget;
  final Widget? leadWidget;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: colorScheme.primary),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leadWidget ?? Text(icon, style: TextStyle(fontSize: 25)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),
          isIncenterWidget ??
              TextButton(
                child: Text(
                  'Изм.',
                  style: TextStyle(color: colorScheme.primary),
                ),

                onPressed: () {},
              ),
        ],
      ),
    );
  }
}
