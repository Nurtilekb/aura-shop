import 'package:flutter/material.dart';

class PressedButton extends StatelessWidget {
  const PressedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.height,
    this.backroundfcolor,
    required this.textstyle,
    this.borderradius,
    this.padding,
    this.imagePath,
    this.borderColor,
  });
  final VoidCallback? onPressed;
  final String text;
  final double? height;
  final Color? backroundfcolor;
  final TextStyle? textstyle;
  final RoundedRectangleBorder? borderradius;
  final EdgeInsetsGeometry? padding;
  final String? imagePath;
  final Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: borderColor != null
            ? BorderSide(color: borderColor!, width: 0.5)
            : null,
        backgroundColor: backroundfcolor ?? Colors.blue,
        foregroundColor: Colors.white,
        padding: padding ?? EdgeInsets.symmetric(vertical: 16),
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
            children: [
              if (imagePath != null)
                Image.asset(imagePath!, width: 24, height: 24),
              if (imagePath != null) SizedBox(width: 20),
              Text(
                text,
                style:
                    textstyle ??
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
