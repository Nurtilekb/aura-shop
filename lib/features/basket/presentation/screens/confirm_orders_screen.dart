import 'package:aurashop/main.dart';
import 'package:aurashop/features/basket/presentation/screens/orderSuccess_screen.dart';
import 'package:aurashop/shared/widgets/basket_widgets/summary_card_widget.dart';
import 'package:aurashop/shared/widgets/basket_widgets/transperet_cont_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ConfirmOrder extends StatefulWidget {
  const ConfirmOrder({super.key});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Оформление',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Адресс доставки',
            style: TextStyle(fontWeight: FontWeight(700), fontSize: 16),
          ),
          TransperetContWidget(
            label: 'Дом · Москва',
            value: 'ул. Тверская, 12, кв. 45 +7 999 123-45-67',
            icon: "📍",
          ),

          Text(
            'Способ доставки',
            style: TextStyle(fontWeight: FontWeight(700), fontSize: 16),
          ),
          TransperetContWidget(
            label: 'Курьер · завтра',
            value: '10:00 – 22:00',
            icon: '♡',
            leadWidget: Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (value) {
                setState(() {
                  isSelected = value!;
                });
              },
            ),
            isIncenterWidget: Column(
              children: [
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'Бесплатно',
                    style: TextStyle(
                      fontWeight: FontWeight(600),
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TransperetContWidget(
            label: 'Пункт выдачи',
            value: '3–4 дня',
            icon: '♡',
            leadWidget: Radio<bool>(
              value: true,
              onChanged: (value) {
                setState(() {
                  isSelected = value!;
                });
              },
            ),
            isIncenterWidget: Column(
              children: [
                SizedBox(height: 10),
                Center(
                  child: Text(
                    '99 ₽',
                    style: TextStyle(fontWeight: FontWeight(600), fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          SummaryCard(
            totalItemsPrice: 11970,
            discount: 1500,
            totalPrice: 10470,
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 2.0)),
          ),

          child: Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              height: 56.0,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderSuccessScreen(
                        onTrackOrder: () {},
                        onContinueShopping: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(),
                            ),
                            ModalRoute.withName('/'),
                          );
                        },
                      ),
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
    );
  }
}
