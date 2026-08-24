import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/shared/widgets/custom_widgets/brand_filter_widget.dart';
import 'package:aurashop/shared/widgets/custom_widgets/slider_widget.dart';
import 'package:flutter/material.dart';

class CatalogFiltersSheet extends StatefulWidget {
  const CatalogFiltersSheet({super.key, required this.state});

  final ThemeState state;

  @override
  State<CatalogFiltersSheet> createState() => _CatalogFiltersSheetState();
}

class _CatalogFiltersSheetState extends State<CatalogFiltersSheet> {
  double _startPrice = 1000;
  double _endPrice = 9000;
  List<String> _selectedBrands = [];
  bool _onlyInStock = true;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.state.directAccentColor;

    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildActions(context, activeColor),
          body: Column(
            children: [
              _buildHandle(),
              _buildHeader(activeColor),
              const Divider(height: 16, thickness: 1),
              Expanded(child: _buildContent(activeColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildHeader(Color activeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Фильтры',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: _resetFilters,
          child: Text(
            'Сбросить',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(Color activeColor) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Диапазон цен
          CustomRangeSlider(
            state: widget.state,
            minValue: 0,
            maxValue: 15000,
            startValue: _startPrice,
            endValue: _endPrice,
            onChanged: (start, end) {
              setState(() {
                _startPrice = start;
                _endPrice = end;
              });
            },
          ),
          const SizedBox(height: 12),

          // 2. Бренды
          BrandFilterWidget(
            activeColor: activeColor,
            initialSelected: _selectedBrands,
            onChanged: (selected) {
              setState(() {
                _selectedBrands = selected;
              });
            },
          ),
          const SizedBox(height: 12),

          // 3. Только в наличии
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.check_circle_outline, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Только в наличии',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: _onlyInStock,
                  activeTrackColor: activeColor,
                  onChanged: (val) {
                    setState(() {
                      _onlyInStock = val;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, Color activeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _resetFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey.shade800,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              child: const Text(
                'Сбросить',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: activeColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Применить',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _startPrice = 0;
      _endPrice = 15000;
      _selectedBrands.clear();
      _onlyInStock = false;
    });
  }
}

