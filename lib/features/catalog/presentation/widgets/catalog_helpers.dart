import 'package:flutter/material.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/bloc/theme/theme_bloc.dart';

enum ProductSortOption { popular, priceAsc, priceDesc, rating }

extension ProductSortOptionX on ProductSortOption {
  String get title {
    switch (this) {
      case ProductSortOption.popular:
        return 'Популярные';
      case ProductSortOption.priceAsc:
        return 'Цена: по возр.';
      case ProductSortOption.priceDesc:
        return 'Цена: по убыв.';
      case ProductSortOption.rating:
        return 'Рейтинг';
    }
  }
}

class CatalogProductCounter extends StatelessWidget {
  final Stream<List<Product>> productsStream;
  const CatalogProductCounter({super.key, required this.productsStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, snapshot) {
        final count = snapshot.data?.length ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            'Найдено товаров: $count',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        );
      },
    );
  }
}

class CatalogProductsSliver extends StatelessWidget {
  final Stream<List<Product>> productsStream;
  final Color activeColor;
  final VoidCallback? onShowAll;

  const CatalogProductsSliver({
    super.key,
    required this.productsStream,
    required this.activeColor,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: productsStream,
      builder: (context, snapshot) {
        final products = snapshot.data ?? [];
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final p = products[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: activeColor,
                child: Text(p.name.isNotEmpty ? p.name[0] : '?'),
              ),
              title: Text(p.name),
              subtitle: Text('${p.price} ₽'),
            );
          }, childCount: products.length),
        );
      },
    );
  }
}

class CatalogSortSheet extends StatelessWidget {
  final ProductSortOption selected;
  final ValueChanged<ProductSortOption> onSelected;
  const CatalogSortSheet({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: ProductSortOption.values.map((opt) {
          return ListTile(
            title: Text(opt.title),
            selected: opt == selected,
            onTap: () => onSelected(opt),
          );
        }).toList(),
      ),
    );
  }
}

class CatalogFilterSheetData {
  final RangeValues priceRange;
  final List<String> sizes;
  final List<String> colors;
  final bool onlyInStock;

  CatalogFilterSheetData({
    required this.priceRange,
    required this.sizes,
    required this.colors,
    required this.onlyInStock,
  });
}

class CatalogFilterSheet extends StatefulWidget {
  final ThemeState? state; // kept for compatibility
  final RangeValues initialPriceRange;
  final List<String> initialSizes;
  final List<String> initialColors;
  final bool initialOnlyInStock;
  final ValueChanged<CatalogFilterSheetData> onApply;

  const CatalogFilterSheet({
    super.key,
    this.state,
    required this.initialPriceRange,
    required this.initialSizes,
    required this.initialColors,
    required this.initialOnlyInStock,
    required this.onApply,
  });

  @override
  State<CatalogFilterSheet> createState() => _CatalogFilterSheetState();
}

class _CatalogFilterSheetState extends State<CatalogFilterSheet> {
  late RangeValues _range;
  late bool _onlyInStock;

  @override
  void initState() {
    super.initState();
    _range = widget.initialPriceRange;
    _onlyInStock = widget.initialOnlyInStock;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RangeSlider(
            values: _range,
            min: 0,
            max: 100000,
            divisions: 100,
            labels: RangeLabels(
              '${_range.start.round()}',
              '${_range.end.round()}',
            ),
            onChanged: (v) => setState(() => _range = v),
          ),
          SwitchListTile(
            title: const Text('Только в наличии'),
            value: _onlyInStock,
            onChanged: (v) => setState(() => _onlyInStock = v),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onApply(
                CatalogFilterSheetData(
                  priceRange: _range,
                  sizes: widget.initialSizes,
                  colors: widget.initialColors,
                  onlyInStock: _onlyInStock,
                ),
              );
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }
}
