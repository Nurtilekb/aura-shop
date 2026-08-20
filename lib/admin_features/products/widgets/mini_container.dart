import 'package:flutter/material.dart';

class MiniContainer extends StatelessWidget {
  const MiniContainer({
    super.key,
    this.size = 40,
    this.backgroundColor,
    this.iconColor,
    this.icon = Icons.add,
    this.iconSize = 20,
    this.onPressed,
    this.borderRadius,
  });

  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData icon;
  final double iconSize;
  final VoidCallback? onPressed;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final effectiveBgColor = backgroundColor ?? theme.primary;
    final effectiveIconColor =
        iconColor ??
        (ThemeData.estimateBrightnessForColor(effectiveBgColor) ==
                Brightness.dark
            ? Colors.white
            : theme.onSurface);
    final radius = borderRadius ?? BorderRadius.circular(12);

    return Material(
      color: effectiveBgColor,
      borderRadius: radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            borderRadius: radius,
          ),
          child: Center(
            child: Icon(icon, size: iconSize, color: effectiveIconColor),
          ),
        ),
      ),
    );
  }
}
