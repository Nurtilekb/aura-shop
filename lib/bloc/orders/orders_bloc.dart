import 'package:aurashop/shared/models/order_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OrdersBloc() : super(OrdersInitial()) {
    on<CreateOrderRequested>(_onCreateOrder);
    on<LoadOrdersRequested>(_onLoadOrders);
    on<LoadAllOrdersRequested>(_onLoadAllOrders);
    on<CancelOrderRequested>(_onCancelOrder);
    on<UpdateOrderStatusRequested>(_onUpdateOrderStatus);
  }

  Future<void> _onCreateOrder(
    CreateOrderRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());

    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(const OrdersError('Пользователь не авторизован'));
        return;
      }

      final orderRef = _firestore.collection('orders').doc();
      final orderData = <String, dynamic>{
        'id': orderRef.id,
        'userId': user.uid,
        'items': event.items,
        'totalAmount': event.totalAmount,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'deliveryMethod': event.deliveryMethod,
        'deliveryAddress': event.deliveryAddress,
      };

      await orderRef.set(orderData);

      final cartSnapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      final batch = _firestore.batch();
      for (final doc in cartSnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      emit(OrderCreated(orderId: orderRef.id));
    } catch (e) {
      emit(OrdersError('Ошибка создания заказа: ${e.toString()}'));
    }
  }

  Future<void> _onLoadOrders(
    LoadOrdersRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());

    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(const OrdersError('Пользователь не авторизован'));
        return;
      }

      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .get();

      final rawOrders =
          snapshot.docs
              .map((doc) => <String, dynamic>{...doc.data(), 'id': doc.id})
              .toList()
            ..sort((a, b) {
              final aDate = a['createdAt'] as Timestamp?;
              final bDate = b['createdAt'] as Timestamp?;

              if (aDate == null && bDate == null) return 0;
              if (aDate == null) return 1;
              if (bDate == null) return -1;

              return bDate.toDate().compareTo(aDate.toDate());
            });

      final orders = rawOrders.map(OrderItem.fromMap).toList();

      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError('Ошибка загрузки заказов: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAllOrders(
    LoadAllOrdersRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());

    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      final rawOrders =
          snapshot.docs
              .map((doc) => <String, dynamic>{...doc.data(), 'id': doc.id})
              .toList();

      final orders = rawOrders.map(OrderItem.fromMap).toList();

      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrdersError('Ошибка загрузки заказов: ${e.toString()}'));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrderRequested event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(const OrdersError('Пользователь не авторизован'));
        return;
      }

      await _firestore.collection('orders').doc(event.orderId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });

      add(const LoadOrdersRequested());
    } catch (e) {
      emit(OrdersError('Ошибка отмены заказа: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusRequested event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      await _firestore.collection('orders').doc(event.orderId).update({
        'status': event.status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      add(const LoadOrdersRequested());
    } catch (e) {
      emit(OrdersError('Ошибка изменения статуса: $e'));
    }
  }
}
