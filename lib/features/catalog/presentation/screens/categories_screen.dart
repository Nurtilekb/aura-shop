import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/repositories/product_repository.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/catalog_filter_button.dart';
import 'package:aurashop/shared/widgets/chip_list.dart';
import 'package:aurashop/features/catalog/presentation/widgets/catalog_helpers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});
  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  static const _categories = [
    'Все',
    'Кроссовки',
    'Кеды',
    'Ботинки',
    'Слипоны',
    'Туфли',
  ];
  final _repository = ProductRepository();
  int _category = 0;
  ProductSortOption _sort = ProductSortOption.popular;
  bool _filterActive = false;
  RangeValues _priceRange = const RangeValues(0, 50000);
  List<String> _sizes = [];
  List<String> _colors = [];
  bool _onlyInStock = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, theme) {
          final color = theme.directAccentColor;
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  title: Text(
                    _category == 0 ? 'Каталог' : _categories[_category],
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
                      onPressed: () => context.router.push(const SearchRoute()),
                    ),
                  ],
                  actionsPadding: const EdgeInsets.only(right: 20),
                ),
                SliverToBoxAdapter(
                  child: CatalogProductCounter(
                    productsStream: _filteredProducts(),
                  ),
                ),
                SliverToBoxAdapter(child: _categoriesBar(color)),
                SliverToBoxAdapter(child: _filtersBar(color, theme)),
                CatalogProductsSliver(
                  productsStream: _filteredProducts(),
                  activeColor: color,
                  onShowAll: _showAll,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _categoriesBar(Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: SizedBox(
      height: 40,
      child: ChipList(
        borderColor: Colors.grey.shade400,
        labels: _categories,
        selectedIndex: _category,
        activeColor: color,
        inactiveColor: Colors.white,
        activeTextColor: Colors.white,
        inactiveTextColor: Colors.grey.shade800,
        spacing: 12,
        horizontalPadding: 20,
        verticalPadding: 8,
        onSelected: (value) => setState(() => _category = value),
      ),
    ),
  );
  Widget _filtersBar(Color color, ThemeState theme) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        CatalogFilterButton(
          activeColor: color,
          icon: Icons.sort,
          label: _sort == ProductSortOption.popular
              ? 'Сортировка'
              : _sort.title,
          isActive: _sort != ProductSortOption.popular,
          onTap: () => _showSort(theme),
        ),
        const SizedBox(width: 12),
        CatalogFilterButton(
          activeColor: color,
          icon: Icons.filter_list,
          label: _filterActive ? 'Фильтры · 1' : 'Фильтры',
          isActive: _filterActive,
          onTap: () => _showFilters(theme),
        ),
      ],
    ),
  );

  Stream<List<Product>> _filteredProducts() => _repository.watchProducts().map((
    products,
  ) {
    final category = _categories[_category];
    var result = products
        .where((product) => category == 'Все' || product.category == category)
        .toList();
    if (_filterActive) {
      result = result.where((product) {
        final price = _price(product.price.toString());
        return price >= _priceRange.start &&
            price <= _priceRange.end &&
            (!_onlyInStock || product.stock == true);
      }).toList();
    }

    result.sort((a, b) {
      switch (_sort) {
        case ProductSortOption.popular:
          return b.reviewsCount.compareTo(a.reviewsCount);
        case ProductSortOption.priceAsc:
          return _price(
            a.price.toString(),
          ).compareTo(_price(b.price.toString()));
        case ProductSortOption.priceDesc:
          return _price(
            b.price.toString(),
          ).compareTo(_price(a.price.toString()));
        case ProductSortOption.rating:
          return b.rating.compareTo(a.rating);
      }
    });
    return result;
  });
  int _price(String value) =>
      int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;

  void _showAll() => setState(() {
    _category = 0;
    _filterActive = false;
  });
  void _showSort(ThemeState theme) => showModalBottomSheet(
    context: context,
    builder: (_) => CatalogSortSheet(
      selected: _sort,
      onSelected: (value) {
        setState(() => _sort = value);
        Navigator.pop(context);
      },
    ),
  );
  void _showFilters(ThemeState theme) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => CatalogFilterSheet(
      state: theme,
      initialPriceRange: _priceRange,
      initialSizes: _sizes,
      initialColors: _colors,
      initialOnlyInStock: _onlyInStock,
      onApply: (data) => setState(() {
        _priceRange = data.priceRange;
        _sizes = data.sizes;
        _colors = data.colors;
        _onlyInStock = data.onlyInStock;
        _filterActive = true;
      }),
    ),
  );
}
