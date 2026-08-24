import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Productcard extends StatelessWidget {
  const Productcard({
    super.key,
    required this.indexx,
    this.title = 'Товар',
    this.price = '2 499 ₽',
    this.rating = 4.8,
    this.onAddToCart,
    this.isFavorite,
    this.product,
    this.onTap,
    this.onFavoriteTap,
    this.isLoading = false,
  });

  final int indexx;
  final String title;
  final String price;
  final double rating;
  final VoidCallback? onAddToCart;
  final bool? isFavorite;
  final Product? product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveProduct =
        product ?? Product(name: title, price: price, rating: rating);

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (onTap != null) {
              onTap!();
            } else {
              context.router.push(
                ProductDetailRoute(product: effectiveProduct),
              );
            }
          },
          child: Skeletonizer(
            enabled: isLoading,
            child: Stack(
              children: [
                Container(
                  width: 190,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Фото ──────────────────────────────────────────
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            if (effectiveProduct.discount != null)
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE54B3C),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '-${effectiveProduct.discount}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // ── Информация ───────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              effectiveProduct.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // Рейтинг
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  size: 13,
                                  color: Color(0xFFFFB800),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  effectiveProduct.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Цена
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        effectiveProduct.price,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Кнопка корзины
                                GestureDetector(
                                  onTap: () {
                                    // поглощаем тап — не всплывает к родителю
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: _CartButton(
                                    accentColor: state.directAccentColor,
                                    onTap:
                                        onAddToCart ??
                                        () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${effectiveProduct.name} добавлен в корзину!',
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                            ),
                                          );
                                        },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Кнопка избранного ─────────────────────────────────
                Positioned(
                  top: 10,
                  right: 10,
                  child: _FavoriteButton(
                    isFavorite: isFavorite == true,
                    accentColor: state.directAccentColor,
                    onTap:
                        onFavoriteTap ??
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${effectiveProduct.name} добавлен в избранное',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
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

// ── Вспомогательные кнопки ────────────────────────────────────────────────────

class _CartButton extends StatelessWidget {
  const _CartButton({required this.accentColor, required this.onTap});

  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 16),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.accentColor,
    required this.onTap,
  });

  final bool isFavorite;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: isFavorite ? Colors.red : Colors.grey.shade500,
          size: 16,
        ),
      ),
    );
  }
}
