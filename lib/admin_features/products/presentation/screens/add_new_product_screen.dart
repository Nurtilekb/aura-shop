import 'package:aurashop/admin_features/products/presentation/widgets/mini_container.dart';
import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:aurashop/shared/widgets/custom_widgets/pressed_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Кроссовки Aura Run 2.0');
    _descriptionController = TextEditingController(
      text: 'Лёгкие беговые кроссовки с амортизацией Aura Foam…',
    );
    _priceController = TextEditingController(text: '4990');
    _stockController = TextEditingController(text: '42');
    _categoryController = TextEditingController(text: 'Обувь');
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,

                  mainAxisSpacing: 12,
                ),
                itemCount: 3,
                itemBuilder: (context, index) => const MiniContainer(
                  size: 60,
                  icon: Icons.add_a_photo_outlined,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                  child: const Padding(
                    padding: EdgeInsets.only(
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
                            Text(
                              'Загрузка в Firebase Storage',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '72%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Divider(height: 8, color: Colors.black),
                        SizedBox(height: 4),
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
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
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
              SizedBox(height: 20),
              AppInputWidget(
                isReadOnly: true,
                onTap: () {
                  showAboutDialog(
                    context: context,
                    children: const [Text('Категория')],
                  );
                },
                filledColor: Colors.transparent,
                label: 'Категория',
                controller: _categoryController,
                trailing: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text(
                    'В наличии',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  Switch(value: true, onChanged: null),
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
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
