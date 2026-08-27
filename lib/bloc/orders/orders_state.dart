part of 'orders_bloc.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class OrdersLoaded extends OrdersState {
  final List<OrderItem> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class OrderCreated extends OrdersState {
  final String orderId;

  const OrderCreated({required this.orderId});

  @override
  List<Object> get props => [orderId];
}

final class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
