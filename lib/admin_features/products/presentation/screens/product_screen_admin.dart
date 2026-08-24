import 'package:aurashop/admin_features/products/presentation/screens/add_new_product_screen.dart';
import 'package:aurashop/admin_features/products/presentation/widgets/admin_product_list_item.dart';
import 'package:aurashop/admin_features/products/presentation/widgets/mini_container.dart';
import 'package:aurashop/bloc/products/products_bloc.dart';
import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ProductScreenAdmin extends StatefulWidget {
  const ProductScreenAdmin({super.key});

  @override
  State<ProductScreenAdmin> createState() => _ProductScreenAdminState();
}

class _ProductScreenAdminState extends State<ProductScreenAdmin> {
  final _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ProductsBloc, ProductsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Товары',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Center(
                  child: Text(
                    '1234',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppInputWidget(
                          controller: _searchController,
                          filledColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          leading: const SizedBox(
                            width: 48,
                            child: Center(
                              child: Text('🔍', style: TextStyle(fontSize: 20)),
                            ),
                          ),
                          hintText: 'Поиск товара',
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      MiniContainer(
                        size: 48,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNewProductScreen(),
                            ),
                          );
                        },
                        icon: Icons.add,
                        backgroundColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: 10,
                    separatorBuilder: (context, index) => Divider(
                      color: theme.dividerColor.withValues(alpha: 0.3),
                      height: 20,
                    ),
                    itemBuilder: (context, index) =>
                        AdminProductListItem(index: index),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
