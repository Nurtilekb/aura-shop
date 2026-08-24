import 'package:aurashop/bloc/products/products_bloc.dart';
import 'package:aurashop/bloc/products/products_event.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'mini_container.dart';

class AdminProductListItem extends StatelessWidget {
  const AdminProductListItem({required this.product, super.key});

  final Product product;

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
                product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.description,
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
              onPressed: () {
                context.router.push(AddNewProductRoute(product2: product));
              },
            ),
            const SizedBox(width: 6),
            MiniContainer(
              icon: Icons.delete_outline,
              backgroundColor: theme.scaffoldBackgroundColor,
              onPressed: () {
                context.read<ProductsBloc>().add(
                  DeleteProductEvent(productId: product.id),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
