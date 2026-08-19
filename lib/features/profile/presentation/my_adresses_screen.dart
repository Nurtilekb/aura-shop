import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:aurashop/shared/widgets/basket_widgets/transperet_cont_widget.dart';
import 'package:aurashop/shared/widgets/custom_widgets/pressed_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MyAdressesScreen extends StatelessWidget {
  const MyAdressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Мои адреса',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
          child: Column(
            children: [
              TransperetContWidget(
                isIncenterWidget: IconButton(
                  iconSize: 20,
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                ),
                label: 'Дом · Москва',
                value: 'ул. Тверская, 12, кв. 45 +7 999 123-45-67',
                icon: "📍",
              ),
              TransperetContWidget(
                isIncenterWidget: IconButton(
                  iconSize: 20,
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                ),
                label: 'Квартира · Москва',
                value: 'ул. Арбат, 5, кв. 12 +7 999 987-65-43',
                icon: "💼",
              ),
              TransperetContWidget(
                isIncenterWidget: IconButton(
                  iconSize: 20,
                  onPressed: () {},
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                ),
                label: 'Дача',
                value: 'МО, г. Химки, ул. Садовая, 3,+7 999 765-43-21',
                icon: "📍",
              ),
              SizedBox(height: 20),
              PressedButton(
                height: 56,
                borderColor: Theme.of(context).primaryColor,

                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAddressScreen()),
                  );
                },
                text: '+ Добавить адрес',
                textstyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum AddressType { home, work, other }

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  AddressType _selectedType = AddressType.home;

  final _cityController = TextEditingController(text: 'Москва');
  final _streetController = TextEditingController(text: 'ул. Тверская, 12');
  final _flatController = TextEditingController(text: '45');
  final _floorController = TextEditingController(text: '7');
  final _commentController = TextEditingController(text: 'Код домофона 45К');

  @override
  void dispose() {
    _cityController.dispose();
    _streetController.dispose();
    _flatController.dispose();
    _floorController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Новый адрес',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Row(
                    children: [
                      _buildTypeChip(type: AddressType.home, label: '🏠 Дом'),
                      const SizedBox(width: 8),
                      _buildTypeChip(
                        type: AddressType.work,
                        label: '💼 Работа',
                      ),
                      const SizedBox(width: 8),
                      _buildTypeChip(
                        type: AddressType.other,
                        label: '📍 Другое',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _CustomTextField(label: 'Город', controller: _cityController),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    label: 'Улица и дом',
                    controller: _streetController,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _CustomTextField(
                          label: 'Квартира',
                          controller: _flatController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CustomTextField(
                          label: 'Этаж',
                          controller: _floorController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _CustomTextField(
                    label: 'Комментарий курьеру',
                    controller: _commentController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    'Сохранить адрес',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip({required AddressType type, required String label}) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _CustomTextField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colorScheme.outline,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        AppInputWidget(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          controller: controller,
          filledColor: Theme.of(context).scaffoldBackgroundColor,
          borderColor: colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ],
    );
  }
}
