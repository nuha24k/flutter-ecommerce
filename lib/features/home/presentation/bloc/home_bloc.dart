import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeCategorySelected>(_onCategorySelected);
    on<HomeSearchQueryChanged>(_onSearchQueryChanged);
    on<HomeTabChanged>(_onTabChanged);
    on<HomeWishlistToggled>(_onWishlistToggled);
    on<HomeLoadingChanged>(_onLoadingChanged);
  }

  void _onCategorySelected(
    HomeCategorySelected event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedCategory: event.category));
  }

  void _onSearchQueryChanged(
    HomeSearchQueryChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  void _onTabChanged(HomeTabChanged event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedTabIndex: event.index));
  }

  void _onWishlistToggled(
    HomeWishlistToggled event,
    Emitter<HomeState> emit,
  ) {
    final ids = Set<String>.from(state.wishlistIds);
    if (ids.contains(event.productId)) {
      ids.remove(event.productId);
    } else {
      ids.add(event.productId);
    }
    emit(state.copyWith(wishlistIds: ids));
  }

  void _onLoadingChanged(
    HomeLoadingChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(isLoading: event.isLoading));
  }
}
