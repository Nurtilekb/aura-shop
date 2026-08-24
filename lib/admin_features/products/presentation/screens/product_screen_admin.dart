import 'package:aurashop/admin_features/products/presentation/screens/add_new_product_screen.dart';
import 'package:aurashop/admin_features/products/presentation/widgets/admin_product_list_item.dart';
import 'package:aurashop/admin_features/products/presentation/widgets/mini_container.dart';
import 'package:aurashop/bloc/products/products_bloc.dart';
import 'package:aurashop/bloc/products/products_event.dart';
import 'package:aurashop/shared/models/product_model.dart';
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
  List<Product> _products = const [];

  @override
  void initState() {
    super.initState();
    context.read<ProductsBloc>().add(LoadProducts());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoaded) {
          _products = state.products;
        }
        final query = _searchController.text.trim().toLowerCase();
        final products = _products
            .where((product) {
              return product.name.toLowerCase().contains(query) ||
                  product.category.toLowerCase().contains(query);
            })
            .toList(growable: false);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Товары',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Center(
                  child: Text(
                    '${_products.length}',
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
                          onChanged: (_) => setState(() {}),
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
                  child: state is ProductsLoading && _products.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : products.isEmpty
                      ? const Center(child: Text('Товары не найдены'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: products.length,
                          separatorBuilder: (context, index) => Divider(
                            color: theme.dividerColor.withValues(alpha: 0.3),
                            height: 20,
                          ),
                          itemBuilder: (context, index) =>
                              AdminProductListItem(product: products[index]),
                        ),
                ),
              ],
            ),
          ),
        );
      },
      listener: _handleAuthState,
    );
  }

  void _handleAuthState(BuildContext context, ProductsState state) {
    if (state is ProductsError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }
}
