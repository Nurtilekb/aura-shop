import 'package:aurashop/shared/models/product_model.dart';
import 'package:equatable/equatable.dart';

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

class LoadProducts extends ProductsEvent {}

class AddProductEvent extends ProductsEvent {
  final Product product;

  const AddProductEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class UpdateProductEvent extends ProductsEvent {
  final Product product;

  const UpdateProductEvent({required this.product});

  @override
  List<Object> get props => [product];
}

class DeleteProductEvent extends ProductsEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
