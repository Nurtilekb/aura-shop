import 'package:aurashop/admin_features/products/presentation/widgets/mini_container.dart';
import 'package:aurashop/bloc/products/products_bloc.dart';
import 'package:aurashop/bloc/products/products_event.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:aurashop/shared/widgets/custom_widgets/pressed_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key, this.product2});

  final Product? product2;

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  bool _manageProducts = false;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _categoryController;

  final List<String> _categories = [
    'Обувь',
    'Для дома',
    'Одежда',
    'Для спорта',
  ];

  @override
  void initState() {
    super.initState();
    final product2 = widget.product2;
    _nameController = TextEditingController(text: product2?.name ?? '');
    _descriptionController = TextEditingController(
      text: product2?.description ?? '',
    );
    _priceController = TextEditingController(
      text: product2?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: product2?.stock == true ? '1' : '0',
    );
    _manageProducts = product2?.stock ?? false;
    _categoryController = TextEditingController(
      text: product2?.category ?? _categories.first,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.82;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Новый товар',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 1,
                itemBuilder: (context, index) => MiniContainer(
                  onPressed: () {},
                  size: 60,
                  icon: Icons.add_a_photo_outlined,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 10,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Загрузка в Firebase Storage',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            color: Theme.of(context).primaryColor,
                            backgroundColor: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppInputWidget(
                filledColor: Colors.transparent,
                label: 'Название',
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: AppInputWidget(
                  label: 'Описание',
                  controller: _descriptionController,
                  filledColor: Colors.transparent,
                  minLines: 5,
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: AppInputWidget(
                      filledColor: Colors.transparent,
                      label: 'Цена, ₽',
                      controller: _priceController,
                      inputType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppInputWidget(
                      filledColor: Colors.transparent,
                      label: 'Остаток',
                      controller: _stockController,
                      inputType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DropdownExample(
                options: _categories,
                selectedValue: _categoryController.text.isNotEmpty
                    ? _categoryController.text
                    : null,
                onChanged: (value) {
                  if (value != null) {
                    _categoryController.text = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'В наличии',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  CupertinoSwitch(
                    value: _manageProducts,
                    activeTrackColor: const Color(0xFF5A49F8),
                    onChanged: (value) {
                      setState(() {
                        _manageProducts = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20),
          child: PressedButton(
            height: 56,
            text: "Save",
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              final product = Product(
                name: _nameController.text.trim(),
                price:
                    double.tryParse(
                      _priceController.text.trim().replaceAll(',', '.'),
                    ) ??
                    0,
                description: _descriptionController.text.trim(),
                category: _categoryController.text.trim(),
                stock: _manageProducts,
              );
              if (widget.product2 == null) {
                context.read<ProductsBloc>().add(
                  AddProductEvent(product: product),
                );
              } else {
                final updatedProduct = widget.product2!.copyWith(
                  name: _nameController.text.trim(),
                  price:
                      double.tryParse(
                        _priceController.text.trim().replaceAll(',', '.'),
                      ) ??
                      0,
                  description: _descriptionController.text.trim(),
                  category: _categoryController.text.trim(),
                  stock: _manageProducts,
                );
                context.read<ProductsBloc>().add(
                  UpdateProductEvent(product: updatedProduct),
                );
              }

              context.router.maybePop();
            },
          ),
        ),
      ),
    );
  }
}

class DropdownExample extends StatelessWidget {
  const DropdownExample({
    super.key,
    required this.options,
    required this.onChanged,
    this.selectedValue,
  });

  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      focusColor: Theme.of(context).scaffoldBackgroundColor,
      initialValue: options.contains(selectedValue) ? selectedValue : null,
      hint: const Text('Выберите категорию'),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
