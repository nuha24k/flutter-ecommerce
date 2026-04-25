part of 'product_detail_bloc.dart';

abstract class ProductDetailEvent {
  const ProductDetailEvent();
}

class ProductDetailSizeSelected extends ProductDetailEvent {
  final String size;
  const ProductDetailSizeSelected(this.size);
}

class ProductDetailColorSelected extends ProductDetailEvent {
  final String color;
  const ProductDetailColorSelected(this.color);
}

class ProductDetailQuantityUpdated extends ProductDetailEvent {
  final int quantity;
  const ProductDetailQuantityUpdated(this.quantity);
}
