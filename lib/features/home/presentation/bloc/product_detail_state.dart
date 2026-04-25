part of 'product_detail_bloc.dart';

class ProductDetailState {
  final String selectedSize;
  final String selectedColor;
  final int quantity;

  const ProductDetailState({
    this.selectedSize = 'M',
    this.selectedColor = 'White',
    this.quantity = 1,
  });

  ProductDetailState copyWith({
    String? selectedSize,
    String? selectedColor,
    int? quantity,
  }) {
    return ProductDetailState(
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
    );
  }
}
