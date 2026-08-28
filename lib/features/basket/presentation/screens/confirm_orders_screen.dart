import 'package:aurashop/bloc/cart/cart_bloc.dart';
import 'package:aurashop/bloc/cart/cart_state.dart';
import 'package:aurashop/bloc/orders/orders_bloc.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/basket_widgets/summary_card_widget.dart';
import 'package:aurashop/shared/widgets/basket_widgets/transperet_cont_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({super.key, this.poduction, this.productlenght});
  final Product? poduction;
  final int? productlenght;
  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  int _deliveryMethod = 0;

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartBloc>().state;
    final ordersState = context.watch<OrdersBloc>().state;
    final cartItems = cartState is CartLoaded ? cartState.items : const [];
    final itemsTotal = cartState is CartLoaded ? cartState.totalPrice : 0.0;
    final deliveryPrice = _deliveryMethod == 0 ? 245.0 : 0.0;

    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OrdersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }

        if (state is OrderCreated) {
          context.router.replace(
            OrderSuccessRoute(
              orderNumber: '#${state.orderId}',
              deliveryTime: _deliveryMethod == 0
                  ? 'завтра, 10:00–22:00'
                  : 'через 3–4 дня',
              onTrackOrder: () {
                context.router.push(OrdersRoute());
              },
              onContinueShopping: () {
                context.router.pushAndPopUntil(
                  const AllCategoriesRoute(),
                  predicate: (route) => false,
                );
              },
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Оформление',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Адрес доставки',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const TransperetContWidget(
              label: 'Дом · Москва',
              value: 'ул. Тверская, 12, кв. 45 +7 999 123-45-67',
              icon: "📍",
            ),
            const SizedBox(height: 12),
            const Text(
              'Способ доставки',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            RadioGroup<int>(
              groupValue: _deliveryMethod,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _deliveryMethod = value);
                }
              },
              child: Column(
                children: [
                  TransperetContWidget(
                    label: 'Курьер · завтра',
                    value: '10:00 – 22:00',
                    icon: '🚚',
                    leadWidget: const Radio<int>(value: 0),
                    isIncenterWidget: const Column(
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            '245 ₽',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TransperetContWidget(
                    label: 'Пункт выдачи',
                    value: '3–4 дня',
                    icon: '📦',
                    leadWidget: const Radio<int>(value: 1),
                    isIncenterWidget: const Column(
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Бесплатно',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (widget.poduction != null)
              SummaryCard(
                itemsCount: widget.productlenght,
                totalItemsPrice: widget.poduction!.price.round(),
                discount: 100,
                totalPrice: widget.poduction!.price.round(),
              ),

            SummaryCard(
              totalItemsPrice: itemsTotal.round(),
              discount: 0,
              totalPrice: (itemsTotal + deliveryPrice).round(),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1.0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 56.0,
                child: ElevatedButton(
                  onPressed: cartItems.isEmpty || ordersState is OrdersLoading
                      ? null
                      : () {
                          context.read<OrdersBloc>().add(
                            CreateOrderRequested(
                              items: cartItems
                                  .map((item) => item.toMap())
                                  .toList(),
                              totalAmount: itemsTotal + deliveryPrice,
                              deliveryMethod: _deliveryMethod == 0
                                  ? 'courier'
                                  : 'pickup',
                              deliveryAddress: 'ул. Тверская, 12, кв. 45',
                            ),
                          );
                        },
                  child: const Text(
                    'Подтвердить заказ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

typedef ConfirmOrder = ConfirmOrderScreen;
