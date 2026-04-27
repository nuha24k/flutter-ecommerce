part of 'order_bloc.dart';

abstract class OrderEvent {}

class OrderAdded extends OrderEvent {
  final List<Map<String, dynamic>> items;
  final double totalAmount;

  OrderAdded({
    required this.items,
    required this.totalAmount,
  });
}

class OrderStatusUpdated extends OrderEvent {
  final String orderId;
  final String newStatus;

  OrderStatusUpdated({
    required this.orderId,
    required this.newStatus,
  });
}
