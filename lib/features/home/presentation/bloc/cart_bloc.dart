import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onItemQuantityUpdated);
    on<CartPaymentMethodSelected>(_onPaymentMethodSelected);
    on<CartCleared>(_onCartCleared);
  }

  void _onItemAdded(CartItemAdded event, Emitter<CartState> emit) {
    final newItems = List<Map<String, dynamic>>.from(state.items);
    newItems.add(event.item);
    emit(state.copyWith(items: newItems));
  }

  void _onItemRemoved(CartItemRemoved event, Emitter<CartState> emit) {
    final newItems = List<Map<String, dynamic>>.from(state.items);
    newItems.removeWhere((item) => (item['product'] as ProductItem).id == event.productId);
    emit(state.copyWith(items: newItems));
  }

  void _onItemQuantityUpdated(CartItemQuantityUpdated event, Emitter<CartState> emit) {
    final newItems = List<Map<String, dynamic>>.from(state.items);
    final index = newItems.indexWhere((item) => (item['product'] as ProductItem).id == event.productId);
    if (index != -1) {
      newItems[index] = {...newItems[index], 'quantity': event.quantity};
      emit(state.copyWith(items: newItems));
    }
  }

  void _onPaymentMethodSelected(CartPaymentMethodSelected event, Emitter<CartState> emit) {
    emit(state.copyWith(selectedPaymentMethod: event.method));
  }

  void _onCartCleared(CartCleared event, Emitter<CartState> emit) {
    emit(state.copyWith(items: []));
  }
}
