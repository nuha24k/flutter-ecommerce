part of 'cart_bloc.dart';

abstract class CartEvent {
  const CartEvent();
}

class CartItemAdded extends CartEvent {
  final Map<String, dynamic> item;
  const CartItemAdded(this.item);
}

class CartItemRemoved extends CartEvent {
  final String productId;
  const CartItemRemoved(this.productId);
}

class CartItemQuantityUpdated extends CartEvent {
  final String productId;
  final int quantity;
  const CartItemQuantityUpdated(this.productId, this.quantity);
}

class CartPaymentMethodSelected extends CartEvent {
  final String method;
  const CartPaymentMethodSelected(this.method);
}

class CartCleared extends CartEvent {
  const CartCleared();
}
