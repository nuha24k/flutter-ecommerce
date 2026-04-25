part of 'cart_bloc.dart';

class CartState {
  final List<Map<String, dynamic>> items;
  final String selectedPaymentMethod;

  const CartState({
    this.items = const [],
    this.selectedPaymentMethod = 'Credit Card',
  });

  double get subtotal {
    double total = 0;
    for (var item in items) {
      final product = item['product']; // ProductItem from home_page.dart
      final price = double.parse(product.price.replaceAll(RegExp(r'[^\d]'), ''));
      total += price * (item['quantity'] as int);
    }
    return total;
  }

  CartState copyWith({
    List<Map<String, dynamic>>? items,
    String? selectedPaymentMethod,
  }) {
    return CartState(
      items: items ?? this.items,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
    );
  }
}
