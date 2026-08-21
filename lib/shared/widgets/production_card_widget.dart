import 'package:aurashop/bloc/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Productcard extends StatelessWidget {
  const Productcard({
    super.key,
    required this.indexx,
    this.title = 'Товар',
    this.price = '2 499 ₽',
    this.rating = 4.8,
    this.onAddToCart,
    this.isFavorite,
  });

  final int indexx;
  final String title;
  final String price;
  final double rating;
  final VoidCallback? onAddToCart;
  final bool? isFavorite;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                          bottom: Radius.circular(16),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 15, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              price,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            _buildAddToCartButton(8, Icons.add, state, null),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: _buildAddToCartButton(
                20,
                Icons.favorite,
                state,
                isFavorite,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddToCartButton(
    double forborder,
    IconData icon,
    ThemeState state,
    bool? isfav,
  ) {
    return GestureDetector(
      onTap: onAddToCart ?? () {},
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: state.directAccentColor,
          borderRadius: BorderRadius.circular(forborder),
        ),
        child: Icon(
          icon,
          color: isfav != null ? Colors.red : Colors.white,
          size: 16,
        ),
      ),
    );
  }
}
