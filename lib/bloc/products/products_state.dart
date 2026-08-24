part of 'products_bloc.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

final class ProductsInitial extends ProductsState {}

final class ProductsLoading extends ProductsState {}

final class ProductsLoaded extends ProductsState {
  final List<Product> products;

  const ProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

final class ProductAdded extends ProductsState {
  final Product product;

  const ProductAdded({required this.product});

  @override
  List<Object> get props => [product];
}

final class ProductUpdated extends ProductsState {
  final Product product;

  const ProductUpdated({required this.product});

  @override
  List<Object> get props => [product];
}

final class ProductDeleted extends ProductsState {
  final String productId;

  const ProductDeleted({required this.productId});

  @override
  List<Object> get props => [productId];
}

final class ProductsError extends ProductsState {
  final String message;

  const ProductsError({required this.message});

  @override
  List<Object> get props => [message];
}
