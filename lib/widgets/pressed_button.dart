import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            shadowColor: Colors.transparent,
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 0.5)
                : null,
            backgroundColor: backgroundColor ?? state.directAccentColor,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                    Image.asset(
                      imagePath!,
                      width: imageWidth,
                      height: imageHeight,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    text,
                    style:
                        textstyle ??
                        TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
