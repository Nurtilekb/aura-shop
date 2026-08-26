// lib/screens/all_categories_screen.dart
import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/repositories/product_repository.dart';
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

  final ProductRepository _productRepository = ProductRepository();

  // Фильтры
  RangeValues _priceRange = const RangeValues(0, 50000);
  List<String> _selectedSizes = [];
  List<String> _selectedColors = [];
  bool _onlyInStock = false;

  static const List<String> _categories = [
    'Все',
    'Кроссовки',
    'Кеды',
    'Ботинки',
    'Слипоны',
    'Туфли',
  ];

  static const List<String> _availableSizes = [
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
  ];
  static const List<String> _availableColors = [
    'Черный',
    'Белый',
    'Красный',
    'Синий',
    'Зеленый',
    'Желтый',
    'Серый',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          final activeColor = state.directAccentColor;
          final themeColor = Theme.of(context);

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                // AppBar
                SliverAppBar(
                  backgroundColor: themeColor.scaffoldBackgroundColor,
                  foregroundColor: themeColor.colorScheme.onSurface,
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

                // Счетчик товаров
                SliverToBoxAdapter(child: _buildProductCounter(state)),

                // Категории
                SliverToBoxAdapter(child: _buildCategories(activeColor)),

                // Фильтры и сортировка
                SliverToBoxAdapter(child: _buildFilters(activeColor, state)),

                // Стрим продуктов
                _buildProductsStream(activeColor),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCounter(ThemeState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StreamBuilder<List<Product>>(
        stream: _getFilteredProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final count = snapshot.data!.length;
            return Text(
              '$count ${_pluralizeProducts(count)}',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCategories(Color activeColor) {
    return Padding(
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
    );
  }

  Widget _buildFilters(Color activeColor, ThemeState state) {
    return Padding(
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
    );
  }

  // Получение стрима с фильтрацией и сортировкой
  Stream<List<Product>> _getFilteredProductsStream() {
    return _productRepository.watchProducts().map((products) {
      final selectedCategory = _categories[_selectedCategoryIndex];
      List<Product> filtered = products.where((p) {
        if (selectedCategory == 'Все') return true;
        return p.category == selectedCategory;
      }).toList();

      // 2. Фильтрация по цене (если активна)
      if (_isFilterActive) {
        filtered = filtered.where((p) {
          final price = _extractPrice(p.price);
          return price >= _priceRange.start && price <= _priceRange.end;
        }).toList();

        // Фильтрация по наличию
        if (_onlyInStock) {
          filtered = filtered.where((p) => p.stock == true).toList();
        }
      }

      // 3. Сортировка
      switch (_selectedSort) {
        case ProductSortOption.popular:
          filtered.sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
          break;
        case ProductSortOption.priceAsc:
          filtered.sort(
            (a, b) => _extractPrice(a.price).compareTo(_extractPrice(b.price)),
          );
          break;
        case ProductSortOption.priceDesc:
          filtered.sort(
            (a, b) => _extractPrice(b.price).compareTo(_extractPrice(a.price)),
          );
          break;
        case ProductSortOption.rating:
          filtered.sort((a, b) => b.rating.compareTo(a.rating));
          break;
      }

      return filtered;
    });
  }

  int _extractPrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^\d]'), '');
    return int.tryParse(cleaned) ?? 0;
  }

  // Основной виджет со стримом продуктов
  Widget _buildProductsStream(Color activeColor) {
    return StreamBuilder<List<Product>>(
      stream: _getFilteredProductsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          );
        }

        // Ошибка
        if (snapshot.hasError) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ошибка загрузки товаров',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }

        // Данные
        final products = snapshot.data ?? [];

        if (products.isEmpty) {
          return SliverFillRemaining(
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedCategoryIndex = 0;
                        _isFilterActive = false;
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
          );
        }

        // Список товаров
        return SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  Productcard(indexx: index, product: products[index]),
              childCount: products.length,
            ),
          ),
        );
      },
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
                ...ProductSortOption.values.map(
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
                    groupValue: _selectedSort,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedSort = val;
                        });
                        Navigator.pop(ctx);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Боттом-шит с фильтрами
  void _showFiltersSheet(BuildContext context, ThemeState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setStateModal) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Заголовок
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Фильтры',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setStateModal(() {
                          _priceRange = const RangeValues(0, 50000);
                          _selectedSizes.clear();
                          _selectedColors.clear();
                          _onlyInStock = false;
                        });
                      },
                      child: Text(
                        'Сбросить',
                        style: TextStyle(color: state.directAccentColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Цена
                const Text(
                  'Цена',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 50000,
                  divisions: 100,
                  activeColor: state.directAccentColor,
                  labels: RangeLabels(
                    '${_priceRange.start.round()} ₽',
                    '${_priceRange.end.round()} ₽',
                  ),
                  onChanged: (values) {
                    setStateModal(() {
                      _priceRange = values;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Наличие
                SwitchListTile(
                  title: const Text('Только в наличии'),
                  value: _onlyInStock,
                  onChanged: (value) {
                    setStateModal(() {
                      _onlyInStock = value;
                    });
                  },
                  activeColor: state.directAccentColor,
                ),
                const SizedBox(height: 10),

                // Размеры (если есть поле sizes)
                const Text(
                  'Размер',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _availableSizes.map((size) {
                    final isSelected = _selectedSizes.contains(size);
                    return FilterChip(
                      label: Text(size),
                      selected: isSelected,
                      onSelected: (selected) {
                        setStateModal(() {
                          if (selected) {
                            _selectedSizes.add(size);
                          } else {
                            _selectedSizes.remove(size);
                          }
                        });
                      },
                      selectedColor: state.directAccentColor.withOpacity(0.2),
                      checkmarkColor: state.directAccentColor,
                      backgroundColor: Colors.grey.shade100,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Цвета (если есть поле colors)
                const Text(
                  'Цвет',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _availableColors.map((color) {
                    final isSelected = _selectedColors.contains(color);
                    return FilterChip(
                      label: Text(color),
                      selected: isSelected,
                      onSelected: (selected) {
                        setStateModal(() {
                          if (selected) {
                            _selectedColors.add(color);
                          } else {
                            _selectedColors.remove(color);
                          }
                        });
                      },
                      selectedColor: state.directAccentColor.withOpacity(0.2),
                      checkmarkColor: state.directAccentColor,
                      backgroundColor: Colors.grey.shade100,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Кнопка Применить
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isFilterActive = true;
                      });
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.directAccentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Применить фильтры',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Склонение слова "товар"
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

class FilterData {
  final RangeValues priceRange;
  final List<String> sizes;
  final List<String> colors;

  const FilterData({
    required this.priceRange,
    required this.sizes,
    required this.colors,
  });
}

class CatalogFiltersSheet extends StatefulWidget {
  final ThemeState state;
  final Function(FilterData) onApply;
  final RangeValues initialPriceRange;
  final List<String> initialSizes;
  final List<String> initialColors;

  const CatalogFiltersSheet({
    super.key,
    required this.state,
    required this.onApply,
    required this.initialPriceRange,
    required this.initialSizes,
    required this.initialColors,
  });

  @override
  State<CatalogFiltersSheet> createState() => _CatalogFiltersSheetState();
}

class _CatalogFiltersSheetState extends State<CatalogFiltersSheet> {
  late RangeValues _priceRange;
  late List<String> _selectedSizes;
  late List<String> _selectedColors;

  final List<String> _availableSizes = [
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
  ];
  final List<String> _availableColors = [
    'Черный',
    'Белый',
    'Красный',
    'Синий',
    'Зеленый',
    'Желтый',
  ];

  @override
  void initState() {
    super.initState();
    _priceRange = widget.initialPriceRange;
    _selectedSizes = List.from(widget.initialSizes);
    _selectedColors = List.from(widget.initialColors);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Фильтры',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _priceRange = const RangeValues(0, 100000);
                    _selectedSizes.clear();
                    _selectedColors.clear();
                  });
                },
                child: Text(
                  'Сбросить',
                  style: TextStyle(color: widget.state.directAccentColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Цена
          const Text(
            'Цена',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 100000,
            divisions: 100,
            activeColor: widget.state.directAccentColor,
            labels: RangeLabels(
              '${_priceRange.start.round()} ₽',
              '${_priceRange.end.round()} ₽',
            ),
            onChanged: (values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          const SizedBox(height: 20),

          // Размеры
          const Text(
            'Размер',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _availableSizes.map((size) {
              final isSelected = _selectedSizes.contains(size);
              return FilterChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSizes.add(size);
                    } else {
                      _selectedSizes.remove(size);
                    }
                  });
                },
                selectedColor: widget.state.directAccentColor.withOpacity(0.2),
                checkmarkColor: widget.state.directAccentColor,
                backgroundColor: Colors.grey.shade100,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Цвета
          const Text(
            'Цвет',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _availableColors.map((color) {
              final isSelected = _selectedColors.contains(color);
              return FilterChip(
                label: Text(color),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedColors.add(color);
                    } else {
                      _selectedColors.remove(color);
                    }
                  });
                },
                selectedColor: widget.state.directAccentColor.withOpacity(0.2),
                checkmarkColor: widget.state.directAccentColor,
                backgroundColor: Colors.grey.shade100,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Кнопка Применить
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onApply(
                  FilterData(
                    priceRange: _priceRange,
                    sizes: _selectedSizes,
                    colors: _selectedColors,
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.state.directAccentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Применить фильтры',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
