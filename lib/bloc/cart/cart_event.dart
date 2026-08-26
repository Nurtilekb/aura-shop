import 'package:aurashop/shared/models/cart_model.dart';

abstract class CartEvent {}

class CartLoadRequested extends CartEvent {} // Загрузка (если нужна явная)

class CartAddRequested extends CartEvent {
  final CartItem item;
  CartAddRequested(this.item);
}

class CartUpdateQuantityRequested extends CartEvent {
  final String productId;
  final int quantity;
  CartUpdateQuantityRequested(this.productId, this.quantity);
}

class CartRemoveRequested extends CartEvent {
  final String productId;
  CartRemoveRequested(this.productId);
}
