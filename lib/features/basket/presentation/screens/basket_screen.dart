import 'package:aurashop/bloc/cart/cart_bloc.dart';
import 'package:aurashop/bloc/cart/cart_event.dart';
import 'package:aurashop/bloc/cart/cart_state.dart';
import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/models/cart_model.dart';
import 'package:aurashop/shared/widgets/basket_widgets/quantity_counter.dart';
import 'package:aurashop/shared/widgets/basket_widgets/summary_card_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final loadedState = state is CartLoaded ? state : null;
        final items = loadedState?.items ?? const <CartItem>[];
        final itemsCount = loadedState?.totalCount ?? 0;
        final totalPrice = loadedState?.totalPrice.round() ?? 0;
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Корзина',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    '$itemsCount ${itemsCount == 1
                        ? "товар"
                        : itemsCount < 5
                        ? "товара"
                        : "товаров"}',
                    style: TextStyle(color: colorScheme.outline, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
          body: state is CartLoading
              ? const Center(child: CircularProgressIndicator())
              : items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: colorScheme.outlineVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Корзина пуста',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Добавьте товары из каталога',
                        style: TextStyle(color: colorScheme.outline),
                      ),
                    ],
                  ),
                )
              : BlocBuilder<ThemeCubit, ThemeState>(
                  builder: (context, state) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ...items.map((item) => _buildCartTile(item)),
                        const SizedBox(height: 12),
                        SummaryCard(
                          itemsCount: itemsCount,
                          totalItemsPrice: totalPrice,
                          discount: 0,
                          totalPrice: totalPrice,
                        ),
                      ],
                    );
                  },
                ),
          bottomNavigationBar: items.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 56.0,
                      child: ElevatedButton(
                        onPressed: () {
                          context.router.push(ConfirmOrderRoute());
                        },
                        child: const Text(
                          'Оформить заказ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildCartTile(CartItem item) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key(item.productId),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          context.read<CartBloc>().add(CartRemoveRequested(item.productId));
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFE54B3C),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 26,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.onTertiaryFixedVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      '${item.price} ₽',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              QuantityCounter(
                quantity: item.quantity,
                onDecrement: () {
                  if (item.quantity > 1) {
                    context.read<CartBloc>().add(
                      CartUpdateQuantityRequested(
                        item.productId,
                        item.quantity - 1,
                      ),
                    );
                  } else {
                    context.read<CartBloc>().add(
                      CartRemoveRequested(item.productId),
                    );
                  }
                },
                onIncrement: () {
                  context.read<CartBloc>().add(
                    CartUpdateQuantityRequested(
                      item.productId,
                      item.quantity + 1,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
