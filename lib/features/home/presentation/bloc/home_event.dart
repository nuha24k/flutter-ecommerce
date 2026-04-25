part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeCategorySelected extends HomeEvent {
  final String category;
  const HomeCategorySelected(this.category);
}

class HomeTabChanged extends HomeEvent {
  final int index;
  const HomeTabChanged(this.index);
}

class HomeWishlistToggled extends HomeEvent {
  final String productId;
  const HomeWishlistToggled(this.productId);
}
