import 'package:flutter/material.dart';

class BrandFilterWidget extends StatefulWidget {
  const BrandFilterWidget({
    super.key,
    this.onChanged,
    this.initialSelected = const [],
    this.activeColor,
  });

  final Function(List<String> selectedBrands)? onChanged;
  final List<String> initialSelected;
  final Color? activeColor;

  @override
  State<BrandFilterWidget> createState() => _BrandFilterWidgetState();
}

class _BrandFilterWidgetState extends State<BrandFilterWidget> {
  late List<String> _selectedBrands;

  final List<Brand> _brands = const [
    Brand(name: 'AURA Original', icon: Icons.star),
    Brand(name: 'Nike', icon: Icons.sports_soccer),
    Brand(name: 'Adidas', icon: Icons.sports),
    Brand(name: 'Puma', icon: Icons.bolt),
  ];

  @override
  void initState() {
    super.initState();
    _selectedBrands = List.from(widget.initialSelected);
  }

  Color get _accent => widget.activeColor ?? const Color(0xFF5D50FE);

  @override
  Widget build(BuildContext context) {
    final allSelected = _selectedBrands.length == _brands.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
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
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: allSelected ? _clearAll : _selectAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  allSelected ? 'Очистить' : 'Выбрать все',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._brands.map((brand) => _buildBrandTile(brand)),
          if (_selectedBrands.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Выбрано: ${_selectedBrands.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: _accent,
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
                  color: isSelected ? _accent : null,
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
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: isSelected ? _accent : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isSelected ? _accent : Colors.grey.shade400,
          width: 1.5,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check, color: Colors.white, size: 15)
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
      _selectedBrands.clear();
    });
    widget.onChanged?.call(_selectedBrands);
  }
}

class Brand {
  final String name;
  final IconData icon;

  const Brand({required this.name, required this.icon});
}

