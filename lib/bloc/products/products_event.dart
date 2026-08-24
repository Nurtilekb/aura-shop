part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class AddProduct extends ProductsEvent {
  final String? prId;
  final String? prName;

  AddProduct({this.prId, this.prName});
}
