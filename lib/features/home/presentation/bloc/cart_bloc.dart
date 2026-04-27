import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_item.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(
    // Initial dummy data to match previous local state
    items: [
      {
        'product': const ProductItem(
          id: 'p1',
          brand: 'The North Face',
          name: 'D2 Utility Dryvent',
          price: '\$572',
          rating: 4.9,
          bgColor: Color(0xFFF5F5F0),
          imagePath: 'assets/images/the_north_face.png',
          type: 'clothing',
        ),
        'quantity': 1,
        'size': 'M',
        'color': 'Black',
      },
      {
        'product': const ProductItem(
          id: 'p3',
          brand: 'Nike',
          name: 'Air Max 270',
          price: '\$189',
          rating: 4.7,
          bgColor: Color(0xFFF5F0F0),
          imagePath: 'assets/images/nike.png',
          type: 'shoes',
        ),
        'quantity': 2,
        'size': '42',
        'color': 'White',
      },
    ],
  )) {
    on<CartItemAdded>(_onItemAdded);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onItemQuantityUpdated);
    on<CartPaymentMethodSelected>(_onPaymentMethodSelected);
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
}
