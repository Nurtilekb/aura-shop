import 'dart:async';

import 'package:aurashop/bloc/products/products_event.dart';
import 'package:aurashop/repositories/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:aurashop/shared/models/product_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductRepository _productRepository;

  ProductsBloc({ProductRepository? productRepository})
    : _productRepository = productRepository ?? ProductRepository(),
      super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<AddProductEvent>(_onAddProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final products = await _productRepository.getProducts();
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onAddProduct(
    AddProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      final product = await _productRepository.addProduct(event.product);
      emit(ProductAdded(product: product));
      emit(ProductsLoaded(products: await _productRepository.getProducts()));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      await _productRepository.updateProduct(event.product);
      emit(ProductUpdated(product: event.product));
      emit(ProductsLoaded(products: await _productRepository.getProducts()));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    try {
      await _productRepository.deleteProduct(event.productId);
      emit(ProductDeleted(productId: event.productId));
      emit(ProductsLoaded(products: await _productRepository.getProducts()));
    } catch (e) {
      emit(ProductsError(message: e.toString()));
    }
  }
}
