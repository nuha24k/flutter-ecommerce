part of 'home_bloc.dart';

class HomeState {
  final String selectedCategory;
  final int selectedTabIndex;
  final Set<String> wishlistIds;

  const HomeState({
    this.selectedCategory = 'Men',
    this.selectedTabIndex = 0,
    this.wishlistIds = const {},
  });

  HomeState copyWith({
    String? selectedCategory,
    int? selectedTabIndex,
    Set<String>? wishlistIds,
  }) {
    return HomeState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      wishlistIds: wishlistIds ?? this.wishlistIds,
    );
  }
}
