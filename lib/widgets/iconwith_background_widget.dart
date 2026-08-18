import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IconWithBack extends StatelessWidget {
  const IconWithBack({
    super.key,
    this.emoji,
    this.sizes,
    this.padding,
    this.bordRadius,
    this.forborder,
    this.backroundcolor,
    this._ontap,
    this.emojiSizes,
  });
  final String? emoji;
  final double? sizes;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? bordRadius;
  final BoxBorder? forborder;
  final Color? backroundcolor;
  final VoidCallback? _ontap;
  final double? emojiSizes;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _ontap,
          child: Container(
            padding: padding ?? EdgeInsets.all(10),
            width: sizes ?? 100,
            height: sizes ?? 100,
            decoration: BoxDecoration(
              borderRadius: bordRadius ?? BorderRadius.circular(25),
              color: backroundcolor ?? state.directAccentColor,
              border:
                  forborder ?? Border.all(width: 0, color: Colors.transparent),
            ),
            child: Center(
              child: Text(
                emoji ?? '',
                style: TextStyle(fontSize: emojiSizes ?? 30),
              ),
            ),
          ),
        );
      },
    );
  }
}
