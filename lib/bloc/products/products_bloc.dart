import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    on<ProductsEvent>((event, emit) {
      on<AddProduct>(_addProducttoList);
    });
  }

  FutureOr<void> _addProducttoList(
    AddProduct event,
    Emitter<ProductsState> emit,
  ) {}
}
