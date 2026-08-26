// lib/bloc/cart/cart_state.dart

import 'package:aurashop/shared/models/cart_model.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  CartLoaded(this.items);

  double get totalPrice => items.fold(
    0.0,
    (sum, item) => sum + (double.parse(item.price.toString()) * item.quantity),
  );
  int get totalCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartError extends CartState {
  final String message;
  CartError(this.message);
}
