part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

final class CreateOrderRequested extends OrdersEvent {
  final List<dynamic> items;
  final double totalAmount;
  final String deliveryMethod;
  final String? deliveryAddress;

  const CreateOrderRequested({
    required this.items,
    required this.totalAmount,
    required this.deliveryMethod,
    this.deliveryAddress,
  });

  @override
  List<Object> get props => [items, totalAmount, deliveryMethod];
}

final class UpdateOrderStatusRequested extends OrdersEvent {
  final String orderId;
  final String status;
  const UpdateOrderStatusRequested({
    required this.orderId,
    required this.status,
  });
}

final class LoadOrdersRequested extends OrdersEvent {
  const LoadOrdersRequested();
}

final class LoadAllOrdersRequested extends OrdersEvent {
  const LoadAllOrdersRequested();
}

final class CancelOrderRequested extends OrdersEvent {
  final String orderId;

  const CancelOrderRequested({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
