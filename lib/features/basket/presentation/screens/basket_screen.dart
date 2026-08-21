import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/shared/models/cart_model.dart';
import 'package:aurashop/features/basket/presentation/screens/confirm_orders_screen.dart';
import 'package:aurashop/shared/widgets/basket_widgets/quantity_counter.dart';
import 'package:aurashop/shared/widgets/basket_widgets/summary_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      title: 'Aura Run 2.0 saaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      price: 4990,
      quantity: 1,
    ),
    CartItem(id: '2', title: 'Худи Oversize', price: 3490, quantity: 2),
    CartItem(id: '2', title: 'Худи Oversize', price: 3490, quantity: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                '${_items.length} товара',
                style: TextStyle(color: colorScheme.outline, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._items.map((item) => _buildCartTile(item)),
              const SizedBox(height: 12),
              const SummaryCard(
                itemsCount: 3,
                totalItemsPrice: 11970,
                discount: 1500,
                totalPrice: 10470,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            height: 56.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfirmOrder()),
                );
              },
              child: const Text(
                'Оформить заказ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartTile(CartItem item) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          setState(() => _items.removeWhere((i) => i.id == item.id));
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
                      item.title,
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
                    setState(() => item.quantity--);
                  }
                },
                onIncrement: () {
                  setState(() => item.quantity++);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
