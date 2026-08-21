import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/features/search/presentation/screens/search_screen.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/chip_list.dart';
import 'package:aurashop/shared/widgets/catalog_filter_button.dart';
import 'package:aurashop/shared/widgets/catalog_filters_sheet.dart';
import 'package:aurashop/shared/widgets/production_card_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCategories extends StatelessWidget {
  AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  title: const Text(
                    'Обувь',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: false,
                  floating: true,
                  snap: true,

                  elevation: 0,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                  actionsPadding: const EdgeInsets.only(right: 20),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${_products.length} товаров',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 40,
                      child: ChipList(
                        borderColor: Colors.grey.shade400,
                        labels: _categories,
                        selectedIndex: 0,
                        activeColor: state.directAccentColor,
                        inactiveColor: Colors.white,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.grey,
                        spacing: 12,
                        horizontalPadding: 20,
                        verticalPadding: 8,
                        onSelected: (_) {},
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        CatalogFilterButton(
                          activeColor: state.directAccentColor,
                          icon: Icons.sort,
                          label: 'Сортировка',
                          onTap: () => _showSortDialog(context, state),
                        ),
                        const SizedBox(width: 12),
                        CatalogFilterButton(
                          activeColor: state.directAccentColor,
                          icon: Icons.filter_list,
                          label: 'Фильтры · 2',
                          onTap: () {},
                          isActive: true,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => Productcard(
                        indexx: index,
                        title: _products[index].name,
                        price: _products[index].price,
                        rating: _products[index].rating,
                        onAddToCart: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${_products[index].name} добавлен в корзину!',
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                      childCount: _products.length,
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSortDialog(BuildContext context, ThemeState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      builder: (_) => CatalogFiltersSheet(state: state),
    );
  }

  final List<String> _categories = [
    'Все',
    'Кроссовки',
    'Ботинки',
    'Кеды',
    'Слипоны',
    'Туфли',
  ];

  final List<Product> _products = [
    Product(name: 'Aura Run 2.0', price: '4 990 ₽', rating: 4.8, discount: 30),
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
    Product(
      name: 'Кроссовки Urban',
      price: '5 490 ₽',
      rating: 4.7,
      discount: 15,
    ),
    Product(
      name: 'Туфли Classic',
      price: '4 290 ₽',
      rating: 4.4,
      discount: null,
    ),
  ];
}
