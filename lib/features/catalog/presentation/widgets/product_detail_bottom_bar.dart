import 'package:aurashop/bloc/cart/cart_bloc.dart';
import 'package:aurashop/bloc/cart/cart_event.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/models/cart_model.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailBottomBar extends StatelessWidget {
  const ProductDetailBottomBar({
    super.key,
    required this.product,
    required this.accentColor,
    required this.quantity,
  });
  final Product product;
  final Color accentColor;
  final int quantity;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      border: Border(
        top: BorderSide(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
    ),
    child: SafeArea(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<CartBloc>().add(
                    CartAddRequested(
                      CartItem.fromProduct(
                        product,
                        quantity: quantity == 0 ? 1 : quantity,
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} добавлен в корзину!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text(
                  'В корзину',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: accentColor, width: 1.5),
                  foregroundColor: accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: quantity == 0
                    ? null
                    : () => context.router.push(
                        ConfirmOrderRoute(
                          poduction: product,
                          productlenght: quantity,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Купить сейчас',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
