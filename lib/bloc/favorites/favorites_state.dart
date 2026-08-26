import 'package:aurashop/shared/models/cart_model.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<CartItem> items;

  FavoritesLoaded(this.items);

  int get totalCount => items.length;
}

class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}
