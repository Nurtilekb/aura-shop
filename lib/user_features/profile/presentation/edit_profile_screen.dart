import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:aurashop/shared/widgets/custom_widgets/pressed_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameChangeController = TextEditingController(text: 'Анна Соколова');
  final _emailChangeController = TextEditingController(text: 'anna@mail.ru');
  final _numberChangeController = TextEditingController(
    text: '+7 999 123-45-67',
  );

  @override
  Widget build(BuildContext context) {
    final colorthem = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Редактировать')),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              spacing: 25,
              children: [
                Stack(
                  children: [
                    IconWithBack(
                      emoji: 'AC',
                      sizes: 120,
                      backroundcolor: colorthem.primaryColor,
                      bordRadius: BorderRadius.circular(100),
                      emojiSizes: 35,
                      color: colorthem.colorScheme.onPrimary,
                      fontwght: FontWeight.bold,
                    ),
                    Positioned(
                      bottom: -1,
                      right: 0,
                      child: IconButton.filled(
                        onPressed: () {},
                        icon: const Icon(Icons.photo_camera),
                        style: IconButton.styleFrom(
                          shadowColor: colorthem.primaryColor.withValues(
                            alpha: 1,
                          ),
                          elevation: 4,
                          backgroundColor:
                              colorthem.colorScheme.onPrimary, // 👈 Цвет фона
                          foregroundColor:
                              colorthem.primaryColor, // 👈 Цвет иконки
                          fixedSize: const Size(40, 40),
                        ),
                      ),
                    ),
                  ],
                ),
                AppInputWidget(
                  filledColor: Colors.transparent,
                  label: 'Имя',
                  borderColor: colorthem.dividerColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                  controller: _nameChangeController,
                ),
                AppInputWidget(
                  filledColor: Colors.transparent,
                  label: 'Email',
                  borderColor: colorthem.dividerColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                  controller: _emailChangeController,
                ),
                AppInputWidget(
                  filledColor: Colors.transparent,
                  label: 'Имя',
                  borderColor: colorthem.dividerColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                  controller: _numberChangeController,
                ),
                AppInputWidget(
                  trailing: SizedBox(
                    width: 30,
                    child: Center(child: Text('📅')),
                  ),
                  onTap: () {},
                  isReadOnly: true,
                  filledColor: Colors.transparent,
                  label: 'Дата рождения',
                  borderColor: colorthem.dividerColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                  hintText: "12.04.1996",
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: PressedButton(
          onPressed: () {},
          text: 'Сохранить',
          backgroundColor: colorthem.primaryColor,
        ),
      ),
    );
  }
}
