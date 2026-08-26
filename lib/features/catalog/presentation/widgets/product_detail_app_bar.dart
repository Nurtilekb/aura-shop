import 'package:aurashop/bloc/favorites/favorites_bloc.dart';
import 'package:aurashop/bloc/favorites/favorites_event.dart';
import 'package:aurashop/bloc/favorites/favorites_state.dart';
import 'package:aurashop/shared/models/cart_model.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:aurashop/shared/widgets/custom_widgets/favorites_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProductDetailAppBar({
    super.key,
    required this.product,
    this.isFavorite,
    this.onFavoriteTap,
  });

  final Product product;
  final bool? isFavorite;
  final VoidCallback? onFavoriteTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => context.router.maybePop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ссылка на товар скопирована'),
              duration: Duration(seconds: 1),
            ),
          ),
        ),
        BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            final favorite = state is FavoritesLoaded
                ? state.items.any((item) => item.productId == product.id)
                : isFavorite == true;
            return FavoriteButton(
              isFavorite: favorite,
              accentColor: color,
              onTap: () {
                if (product.id.isEmpty) return;
                onFavoriteTap?.call();
                if (onFavoriteTap == null) {
                  context.read<FavoritesBloc>().add(
                    FavoritesToggleRequested(CartItem.fromProduct(product)),
                  );
                }
              },
            );
          },
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
