import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/chip_list.dart';
import 'package:aurashop/shared/widgets/catalog_filter_button.dart';
import 'package:aurashop/shared/widgets/catalog_filters_sheet.dart';
import 'package:aurashop/shared/widgets/production_card_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ProductSortOption {
  popular('По популярности'),
  priceAsc('Сначала дешевле'),
  priceDesc('Сначала дороже'),
  rating('По рейтингу');

  final String title;
  const ProductSortOption(this.title);
}

@RoutePage()
class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  int _selectedCategoryIndex = 0;
  ProductSortOption _selectedSort = ProductSortOption.popular;
  bool _isFilterActive = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  static const List<String> _categories = [
    'Все',
    'Кроссовки',
    'Кеды',
    'Ботинки',
    'Слипоны',
    'Туфли',
  ];

  static const List<Product> _allProducts = [
    Product(
      name: 'Aura Run 2.0',
      price: '4 990 ₽',
      rating: 4.8,
      discount: 30,
      category: 'Кроссовки',
      description:
          'Легкие беговые кроссовки нового поколения с амортизирующей подошвой.',
    ),
    Product(
      name: 'Кроссовки Urban',
      price: '5 490 ₽',
      rating: 4.7,
      discount: 15,
      category: 'Кроссовки',
      description:
          'Городские кроссовки с улучшенной фиксацией пятки и стильным силуэтом.',
    ),
    Product(
      name: 'Кеды Classic White',
      price: '3 290 ₽',
      rating: 4.6,
      discount: null,
      category: 'Кеды',
      description: 'Минималистичные белые кеды из мягкой натуральной кожи.',
    ),
    Product(
      name: 'Кеды Retro Canvas',
      price: '2 990 ₽',
      rating: 4.5,
      discount: 10,
      category: 'Кеды',
      description: 'Тканевые кеды в ретро-стиле на гибкой резиновой подошве.',
    ),
    Product(
      name: 'Ботинки Trek Pro',
      price: '7 990 ₽',
      rating: 4.9,
      discount: null,
      category: 'Ботинки',
      description:
          'Надежные ботинки для походов и холодной погоды с водостойким покрытием.',
    ),
    Product(
      name: 'Ботинки Chelsea Leather',
      price: '6 990 ₽',
      rating: 4.8,
      discount: null,
      category: 'Ботинки',
      description:
          'Классические кожаные челси с эластичными боковыми вставками.',
    ),
    Product(
      name: 'Слипоны Aura Air',
      price: '2 790 ₽',
      rating: 4.5,
      discount: null,
      category: 'Слипоны',
      description:
          'Удобные слипоны без шнурков для максимального комфорта каждый день.',
    ),
    Product(
      name: 'Туфли Classic Derby',
      price: '4 290 ₽',
      rating: 4.4,
      discount: null,
      category: 'Туфли',
      description:
          'Элегантные классические туфли дерби для официальных и деловых мероприятий.',
    ),
  ];

  List<Product> get _filteredAndSortedProducts {
    final selectedCategory = _categories[_selectedCategoryIndex];

    List<Product> list = _allProducts.where((p) {
      if (selectedCategory == 'Все') return true;
      return p.category == selectedCategory;
    }).toList();

    switch (_selectedSort) {
      case ProductSortOption.popular:
        list.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
        break;
      case ProductSortOption.priceAsc:
        list.sort(
          (a, b) => _extractPrice(a.price).compareTo(_extractPrice(b.price)),
        );
        break;
      case ProductSortOption.priceDesc:
        list.sort(
          (a, b) => _extractPrice(b.price).compareTo(_extractPrice(a.price)),
        );
        break;
      case ProductSortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return list;
  }

  int _extractPrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final products = _filteredAndSortedProducts;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final activeColor = state.directAccentColor;

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  title: Text(
                    _selectedCategoryIndex == 0
                        ? 'Каталог'
                        : _categories[_selectedCategoryIndex],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                        context.router.push(const SearchRoute());
                      },
                    ),
                  ],
                  actionsPadding: const EdgeInsets.only(right: 20),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '${products.length} ${_pluralizeProducts(products.length)}',
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
                        selectedIndex: _selectedCategoryIndex,
                        activeColor: activeColor,
                        inactiveColor: Colors.white,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.grey.shade800,
                        spacing: 12,
                        horizontalPadding: 20,
                        verticalPadding: 8,
                        onSelected: (index) {
                          setState(() {
                            _selectedCategoryIndex = index;
                          });
                        },
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
                          activeColor: activeColor,
                          icon: Icons.sort,
                          label: _selectedSort == ProductSortOption.popular
                              ? 'Сортировка'
                              : _selectedSort.title,
                          isActive: _selectedSort != ProductSortOption.popular,
                          onTap: () => _showSortDialog(context, state),
                        ),
                        const SizedBox(width: 12),
                        CatalogFilterButton(
                          activeColor: activeColor,
                          icon: Icons.filter_list,
                          label: _isFilterActive ? 'Фильтры · 1' : 'Фильтры',
                          isActive: _isFilterActive,
                          onTap: () => _showFiltersSheet(context, state),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_isLoading)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.75,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            const Productcard(indexx: 0, isLoading: true),
                        childCount: 6,
                      ),
                    ),
                  )
                else if (products.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'В этой категории пока нет товаров',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategoryIndex = 0;
                              });
                            },
                            child: Text(
                              'Показать все товары',
                              style: TextStyle(color: activeColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
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
                          product: products[index],
                        ),
                        childCount: products.length,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Text(
                    'Сортировка',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                RadioGroup<ProductSortOption>(
                  groupValue: _selectedSort,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedSort = val);
                      Navigator.pop(ctx);
                    }
                  },
                  child: Column(
                    children: ProductSortOption.values
                        .map(
                          (option) => RadioListTile<ProductSortOption>(
                            title: Text(
                              option.title,
                              style: TextStyle(
                                fontWeight: _selectedSort == option
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedSort == option
                                    ? state.directAccentColor
                                    : null,
                              ),
                            ),
                            value: option,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFiltersSheet(BuildContext context, ThemeState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CatalogFiltersSheet(state: state),
    ).then((_) {
      setState(() {
        _isFilterActive = !_isFilterActive;
      });
    });
  }

  String _pluralizeProducts(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'товар';
    } else if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 10 || count % 100 >= 20)) {
      return 'товара';
    } else {
      return 'товаров';
    }
  }
}

typedef AllCategories = AllCategoriesScreen;
