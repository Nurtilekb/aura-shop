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

  @override
  void initState() {
    super.initState();
    final _product2 = widget.product2;
    _nameController = TextEditingController(text: _product2?.name ?? '');
    _descriptionController = TextEditingController(
      text: _product2?.description ?? '',
    );
    _priceController = TextEditingController(text: _product2?.price ?? '');
    _stockController = TextEditingController(
      text: _product2?.stock == true ? '1' : '0',
    );
    _categoryController = TextEditingController(
      text: _product2?.category ?? 'Обувь',
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
                price: _priceController.text.trim(),
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
                  price: _priceController.text.trim(),
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
