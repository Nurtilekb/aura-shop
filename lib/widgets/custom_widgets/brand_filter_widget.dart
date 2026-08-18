import 'package:flutter/material.dart';

class BrandFilterWidget extends StatefulWidget {
  const BrandFilterWidget({
    super.key,
    this.onChanged,
    this.initialSelected = const [],
  });

  final Function(List<String> selectedBrands)? onChanged;
  final List<String> initialSelected;

  @override
  State<BrandFilterWidget> createState() => _BrandFilterWidgetState();
}

class _BrandFilterWidgetState extends State<BrandFilterWidget> {
  late List<String> _selectedBrands;

  final List<Brand> _brands = const [
    Brand(name: 'Aura', icon: Icons.star),
    Brand(name: 'Nike', icon: Icons.sports_soccer),
    Brand(name: 'Adidas', icon: Icons.sports),
  ];

  @override
  void initState() {
    super.initState();
    _selectedBrands = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Бренд',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              // Кнопка "Выбрать все"
              TextButton(
                onPressed: _selectAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Выбрать все',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Кнопка "Очистить"
              TextButton(
                onPressed: _clearAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Очистить',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ..._brands.map((brand) => _buildBrandTile(brand)).toList(),

          if (_selectedBrands.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Выбрано: ${_selectedBrands.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.purple.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBrandTile(Brand brand) {
    final isSelected = _selectedBrands.contains(brand.name);

    return GestureDetector(
      onTap: () => _toggleBrand(brand.name),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: Row(
          children: [
            _buildCustomCheckbox(isSelected),

            const SizedBox(width: 12),
            Expanded(
              child: Text(
                brand.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.purple.shade700 : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomCheckbox(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: isSelected ? Colors.purple.shade700 : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? Colors.purple.shade700 : Colors.grey.shade400,
          width: 2,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : null,
    );
  }

  void _toggleBrand(String brand) {
    setState(() {
      if (_selectedBrands.contains(brand)) {
        _selectedBrands.remove(brand);
      } else {
        _selectedBrands.add(brand);
      }
    });
    widget.onChanged?.call(_selectedBrands);
  }

  void _selectAll() {
    setState(() {
      _selectedBrands = _brands.map((b) => b.name).toList();
    });
    widget.onChanged?.call(_selectedBrands);
  }

  void _clearAll() {
    setState(() {
      _selectedBrands = [];
    });
    widget.onChanged?.call(_selectedBrands);
  }
}

// Модель бренда
class Brand {
  final String name;
  final IconData icon;

  const Brand({required this.name, required this.icon});
}
