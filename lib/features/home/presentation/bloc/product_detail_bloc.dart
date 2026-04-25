import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc() : super(const ProductDetailState()) {
    on<ProductDetailSizeSelected>(_onSizeSelected);
    on<ProductDetailColorSelected>(_onColorSelected);
    on<ProductDetailQuantityUpdated>(_onQuantityUpdated);
  }

  void _onSizeSelected(ProductDetailSizeSelected event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(selectedSize: event.size));
  }

  void _onColorSelected(ProductDetailColorSelected event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(selectedColor: event.color));
  }

  void _onQuantityUpdated(ProductDetailQuantityUpdated event, Emitter<ProductDetailState> emit) {
    emit(state.copyWith(quantity: event.quantity));
  }
}
