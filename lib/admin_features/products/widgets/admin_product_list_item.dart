import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:flutter/material.dart';

import 'mini_container.dart';

class AdminProductListItem extends StatelessWidget {
  const AdminProductListItem({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconWithBack(
          backroundcolor: theme.dividerColor,
          sizes: 65,
          bordRadius: BorderRadius.circular(12),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Description of Product ${index + 1}',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.7,
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MiniContainer(
              icon: Icons.edit_outlined,
              backgroundColor: theme.scaffoldBackgroundColor,
              onPressed: () {},
            ),
            const SizedBox(width: 6),
            MiniContainer(
              icon: Icons.delete_outline,
              backgroundColor: theme.scaffoldBackgroundColor,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
