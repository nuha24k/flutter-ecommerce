import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderState()) {
    on<OrderAdded>(_onOrderAdded);
    on<OrderStatusUpdated>(_onOrderStatusUpdated);
  }

  void _onOrderAdded(OrderAdded event, Emitter<OrderState> emit) {
    final random = Random();
    final newOrderId = 'MZ-${1000 + random.nextInt(9000)}';

    final newOrder = {
      'id': newOrderId,
      'items': List<Map<String, dynamic>>.from(event.items),
      'totalAmount': event.totalAmount,
      'status': 'Paid', // Default status after checkout
      'date': DateTime.now(),
    };

    final newOrdersList = List<Map<String, dynamic>>.from(state.orders);
    newOrdersList.insert(0, newOrder);

    emit(state.copyWith(orders: newOrdersList));
  }

  void _onOrderStatusUpdated(OrderStatusUpdated event, Emitter<OrderState> emit) {
    final newOrdersList = List<Map<String, dynamic>>.from(state.orders);
    final index = newOrdersList.indexWhere((order) => order['id'] == event.orderId);

    if (index != -1) {
      newOrdersList[index] = {
        ...newOrdersList[index],
        'status': event.newStatus,
      };
      emit(state.copyWith(orders: newOrdersList));
    }
  }
}
