import 'dart:async';

import 'package:aurashop/bloc/products/products_event.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:aurashop/shared/models/product_model.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final List<Product> _products = [];

  ProductsBloc() : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  FutureOr<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      emit(ProductsLoaded(products: _products));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  FutureOr<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      _products.add(event.product);
      emit(ProductAdded(product: event.product));
      emit(ProductsLoaded(products: List.unmodifiable(_products)));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  FutureOr<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final index = _products.indexWhere((p) => p.id == event.product.id);
      if (index != -1) {
        _products[index] = event.product;
        emit(ProductUpdated(product: event.product));
        emit(ProductsLoaded(products: List.unmodifiable(_products)));
      } else {
        emit(ProductsError(message: 'Продукт не найден'));
      }
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  FutureOr<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = _products.removeWhere((p) => p.id == event.productId);
      emit(ProductDeleted(productId: event.productId));
      emit(ProductsLoaded(products: List.unmodifiable(_products)));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }
}
