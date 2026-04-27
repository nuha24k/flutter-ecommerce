part of 'home_bloc.dart';

class HomeState {
  final String selectedCategory;
  final String searchQuery;
  final int selectedTabIndex;
  final Set<String> wishlistIds;
  final bool isLoading;

  const HomeState({
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.selectedTabIndex = 0,
    this.wishlistIds = const {},
    this.isLoading = true,
  });

  HomeState copyWith({
    String? selectedCategory,
    String? searchQuery,
    int? selectedTabIndex,
    Set<String>? wishlistIds,
    bool? isLoading,
  }) {
    return HomeState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      wishlistIds: wishlistIds ?? this.wishlistIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
