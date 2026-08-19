import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PressedButton extends StatelessWidget {
  const PressedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.height = 52,
    this.backgroundColor,
    this.textstyle,
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
  final Color? backgroundColor;
  final TextStyle? textstyle;
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
        // 1. Вычисляем цвет фона
        final effectiveBgColor = backgroundColor ?? state.directAccentColor;

        // 2. Автоматически определяем цвет текста/иконок и эффекта нажатия для контраста
        final isDarkBg =
            ThemeData.estimateBrightnessForColor(effectiveBgColor) ==
            Brightness.dark;
        final defaultFgColor = isDarkBg ? Colors.white : Colors.black;
        final effectiveFgColor = textstyle?.color ?? defaultFgColor;

        return FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: effectiveBgColor,
            foregroundColor: effectiveFgColor,
            // 3. Явно задаем цвет всплеска при нажатии
            overlayColor: effectiveFgColor.withOpacity(0.12),
            shadowColor: Colors.transparent,
            elevation: 0,
            minimumSize: Size(double.infinity, height ?? 52),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1)
                : null,
            shape:
                borderradius ??
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
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
                    (textstyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ))
                        .copyWith(color: effectiveFgColor),
              ),
            ],
          ),
        );
      },
    );
  }
}
