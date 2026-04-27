part of 'order_bloc.dart';

class OrderState {
  final List<Map<String, dynamic>> orders;

  OrderState({this.orders = const []});

  OrderState copyWith({
    List<Map<String, dynamic>>? orders,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
    );
  }
}
