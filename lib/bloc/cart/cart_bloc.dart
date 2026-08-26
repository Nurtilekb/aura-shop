import 'package:aurashop/shared/models/cart_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<CartLoadRequested>(_onLoad);
    on<CartAddRequested>(_onAdd);
    on<CartUpdateQuantityRequested>(_onUpdate);
    on<CartRemoveRequested>(_onRemove);
    add(CartLoadRequested());
  }

  Future<void> _onLoad(CartLoadRequested event, Emitter<CartState> emit) async {
    emit(CartLoading());
    await emit.forEach<List<CartItem>>(
      repository.watchCart(),
      onData: CartLoaded.new,
      onError: (error, _) => CartError(error.toString()),
    );
  }

  Future<void> _onAdd(CartAddRequested event, Emitter<CartState> emit) async {
    try {
      await repository.addToCart(event.item);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    CartUpdateQuantityRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await repository.updateQuantity(event.productId, event.quantity);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemove(
    CartRemoveRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await repository.removeFromCart(event.productId);
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
