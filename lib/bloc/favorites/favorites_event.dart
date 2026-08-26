import 'package:aurashop/shared/models/cart_model.dart';

abstract class FavoritesEvent {}

class FavoritesLoadRequested extends FavoritesEvent {}

class FavoritesToggleRequested extends FavoritesEvent {
  final CartItem item;
  FavoritesToggleRequested(this.item);
}

class FavoritesRemoveRequested extends FavoritesEvent {
  final String productId;
  FavoritesRemoveRequested(this.productId);
}

class FavoritesClearRequested extends FavoritesEvent {}
