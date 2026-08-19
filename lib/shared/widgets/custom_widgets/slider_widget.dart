import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';

class CustomRangeSlider extends StatefulWidget {
  const CustomRangeSlider({
    super.key,
    this.minValue = 0,
    this.maxValue = 10000,
    this.startValue = 2000,
    this.endValue = 8000,
    this.onChanged,
    required this.state,
  });

  final double minValue;
  final double maxValue;
  final double startValue;
  final double endValue;
  final Function(double start, double end)? onChanged;
  final ThemeState? state;

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late double _startValue;
  late double _endValue;

  @override
  void initState() {
    super.initState();
    _startValue = widget.startValue;
    _endValue = widget.endValue;
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
          // Заголовок
          const Text(
            'Цена',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceChip(_startValue),
              _buildPriceChip(_endValue),
            ],
          ),
          const SizedBox(height: 16),

          RangeSlider(
            values: RangeValues(_startValue, _endValue),
            min: widget.minValue,
            max: widget.maxValue,
            divisions: 100,
            activeColor: widget.state!.directAccentColor,
            inactiveColor: Colors.grey.shade200,
            overlayColor: WidgetStateProperty.all(
              Colors.purple.withValues(alpha: 0.1),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _startValue = values.start;
                _endValue = values.end;
              });
              widget.onChanged?.call(_startValue, _endValue);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceChip(double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Text(
        '${value.toStringAsFixed(0)} ₽',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
    );
  }
}
