import 'package:aurashop/features/catalog/presentation/widgets/product_detail_app_bar.dart';
import 'package:aurashop/features/catalog/presentation/widgets/product_detail_bottom_bar.dart';
import 'package:aurashop/features/catalog/presentation/widgets/product_detail_content.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
    this.isFavorite,
    this.onFavoriteTap,
  });

  final Product product;
  final bool? isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: ProductDetailAppBar(
        product: product,
        isFavorite: widget.isFavorite,
        onFavoriteTap: widget.onFavoriteTap,
      ),
      body: ProductDetailContent(
        product: product,
        quantity: _quantity,
        onQuantityChanged: (value) => setState(() => _quantity = value),
      ),
      bottomNavigationBar: ProductDetailBottomBar(
        product: product,
        accentColor: accentColor,
        quantity: _quantity,
      ),
    );
  }
}
