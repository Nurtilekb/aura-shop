import 'package:flutter/material.dart';

class PressedButton extends StatelessWidget {
  const PressedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.height,
    this.backgroundColor, // ← Исправлено название
    this.textstyle, // ← Убрал required
    this.borderradius,
    this.padding,
    this.imagePath,
    this.borderColor,
    this.imageWidth = 24,
    this.imageHeight = 24,
  });

  final VoidCallback? onPressed;
  final String text;
  final double? height;
  final Color? backgroundColor; // ← Исправлено название
  final TextStyle? textstyle; // ← Убрал required
  final RoundedRectangleBorder? borderradius;
  final EdgeInsetsGeometry? padding;
  final String? imagePath;
  final Color? borderColor;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: 0.5)
            : null,
        backgroundColor: backgroundColor ?? Colors.blue, // ← Исправлено
        foregroundColor: Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
        shape:
            borderradius ??
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: SizedBox(
        width: double.infinity,
        height: height ?? 30,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imagePath != null && imagePath!.isNotEmpty) ...[
                Image.asset(imagePath!, width: imageWidth, height: imageHeight),
                const SizedBox(width: 12),
              ],
              Text(
                text,
                style:
                    textstyle ??
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
