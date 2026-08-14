import 'package:flutter/material.dart';

class IconWithBack extends StatelessWidget {
  const IconWithBack({super.key, this._imagePath, this.sizes, this.padding});
  final String? _imagePath;
  final double? sizes;
  final EdgeInsetsGeometry? padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(10),
      width: sizes ?? 100,
      height: sizes ?? 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xFF5D50FE).withOpacity(0.1),
        border: Border.all(width: 0, color: Colors.transparent),
      ),
      child: Image.asset(
        _imagePath ?? 'assets/icons/pochta.png',
        width: 25,
        height: 25,
      ),
    );
  }
}
