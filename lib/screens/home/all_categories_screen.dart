import 'package:aurashop/screens/search/search_screen.dart';
import 'package:aurashop/widgets/custom_widgets/brand_filter_widget.dart';
import 'package:aurashop/widgets/custom_widgets/slider_widget.dart';
import 'package:aurashop/widgets/production_card_widget.dart';
import 'package:flutter/material.dart';

class AllCategories extends StatelessWidget {
  AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
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
                      MaterialPageRoute(builder: (context) => SearchScreen()),
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
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) =>
                        _buildCategoryChip(_categories[index], index == 0),
                  ),
                ),
              ),
            ),

            // Фильтры и сортировка
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _buildFilterButton(
                      icon: Icons.sort,
                      label: 'Сортировка',
                      onTap: () => _showSortDialog(context),
                    ),
                    const SizedBox(width: 12),
                    _buildFilterButton(
                      icon: Icons.filter_list,
                      label: 'Фильтры · 2',
                      onTap: () {},
                      isActive: true,
                    ),
                  ],
                ),
              ),
            ),

            // Сетка товаров с вашим Productcard
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      // 👇 Добавляем функционал для кнопки +
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

            // Нижний отступ
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  // Категории (ваша функция, не трогаем)
  Widget _buildCategoryChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.purple.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? Colors.purple.shade700 : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.grey.shade700,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,

          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.purple.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? Colors.purple.shade700 : Colors.grey.shade300,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? Colors.purple.shade700 : Colors.grey.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isActive
                      ? Colors.purple.shade700
                      : Colors.grey.shade700,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 👈 Важно для полного размера
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        top: false,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Фильтры',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Cбросить',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(height: 20, thickness: 1),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),

                        child: SizedBox(
                          height: 100, // 👈 Ограничиваем высоту
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Заголовок',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Этот контент займет все свободное  ',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Цена
                      CustomRangeSlider(
                        minValue: 0,
                        maxValue: 10000,
                        startValue: 2000,
                        endValue: 8000,
                        onChanged: (start, end) {
                          // Обработка изменения цены
                        },
                      ),
                      const SizedBox(height: 24),

                      BrandFilterWidget(onChanged: (selected) {}),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          // Кнопка "Сбросить" (белая)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // // Сбросить фильтры
                                // _resetFilters();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.purple.shade700,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(
                                  color: Colors.purple.shade700,
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                'Сбросить',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Кнопка "Применить" (фиолетовая)
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // // Применить фильтры
                                // _applyFilters();
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Применить',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Данные (ваши, не трогаем)
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

// Модель товара (ваша, не трогаем)
class Product {
  final String name;
  final String price;
  final double rating;
  final int? discount;

  const Product({
    required this.name,
    required this.price,
    this.rating = 4.8,
    this.discount,
  });
}
