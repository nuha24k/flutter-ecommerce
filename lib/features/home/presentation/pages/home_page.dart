import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../data/models/product_catalog.dart';
import '../../data/models/product_item.dart';
import '../bloc/home_bloc.dart';
import '../widgets/home_header.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_promo_banner.dart';
import '../widgets/home_category_filter.dart';
import '../widgets/product_card.dart';
import '../widgets/home_bottom_nav.dart';
import 'wishlist_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  List<ProductItem> _getFilteredProducts(HomeState state) {
    return ProductCatalog.products.where((p) {
      final matchesSearch = state.searchQuery.isEmpty ||
          p.name.toLowerCase().contains(state.searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(state.searchQuery.toLowerCase());

      bool matchesCategory = true;
      if (state.selectedCategory != 'All') {
        final catLower = state.selectedCategory.toLowerCase();
        if (catLower == 'shoes') {
          matchesCategory = p.type == 'shoes';
        } else if (catLower == 'apparel') {
          matchesCategory = p.type == 'clothing';
        } else {
          matchesCategory = p.name.toLowerCase().contains(catLower) ||
              p.brand.toLowerCase().contains(catLower);
          if (!matchesCategory) {
            matchesCategory = (catLower == 'men' && p.type == 'clothing') ||
                (catLower == 'sport' && p.type == 'shoes');
          }
        }
      }
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    // Trigger loading state via BLoC (menggantikan setState lokal)
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        context.read<HomeBloc>().add(const HomeLoadingChanged(false));
      }
    });

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: _buildCurrentTab(context, state),
            ),
          ),
          bottomNavigationBar: HomeBottomNav(
            selectedIndex: state.selectedTabIndex,
          ),
        );
      },
    );
  }

  Widget _buildCurrentTab(BuildContext context, HomeState state) {
    switch (state.selectedTabIndex) {
      case 1:
        return const WishlistPage();
      case 2:
        return const CartPage();
      case 3:
        return const ProfilePage();
      case 0:
      default:
        return _buildHomeTab(context, state);
    }
  }

  Widget _buildHomeTab(BuildContext context, HomeState state) {
    final filteredProducts = _getFilteredProducts(state);

    return SafeArea(
      child: Skeletonizer(
        enabled: state.isLoading,
        child: AnimationLimiter(
          key: ValueKey(state.selectedCategory),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: HomeHeader()),
              const SliverToBoxAdapter(child: HomeSearchBar()),
              const SliverToBoxAdapter(child: HomePromoBanner()),
              SliverToBoxAdapter(
                child: HomeCategoryFilter(
                  selectedCategory: state.selectedCategory,
                ),
              ),
              SliverToBoxAdapter(child: _buildSectionTitle('Most Popular')),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => AnimationConfiguration.staggeredGrid(
                      position: i,
                      duration: const Duration(milliseconds: 500),
                      columnCount: 2,
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ProductCard(
                            product: filteredProducts[i],
                            isWishlisted: state.wishlistIds
                                .contains(filteredProducts[i].id),
                          ),
                        ),
                      ),
                    ),
                    childCount: filteredProducts.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'See all',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
