import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/production_card_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Product> products = [
      Product(
        name: 'Aura Run 2.0',
        price: '4 990 ₽',
        rating: 4.8,
        discount: 30,
      ),
      Product(
        name: 'Кеды Classic White',
        price: '3 290 ₽',
        rating: 4.6,
        discount: null,
      ),
      Product(
        name: 'Ботинки Trek Pro',
        price: '7 990 ₽',
        rating: 4.9,
        discount: null,
      ),
      Product(
        name: 'Слипоны Aura Air',
        price: '2 790 ₽',
        rating: 4.5,
        discount: null,
      ),
    ];
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Избранное',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: Text(
                '${products.length} товара',
                style: TextStyle(color: colorScheme.outline, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsetsGeometry.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Productcard(
                    isFavorite: true,
                    indexx: index,
                    title: products[index].name,
                    price: products[index].price,
                    rating: products[index].rating,
                    onAddToCart: () {
                      // 👇 Добавляем функционал для кнопки +
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${products[index].name} добавлен в корзину!',
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                  childCount: products.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
