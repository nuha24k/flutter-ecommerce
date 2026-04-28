import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/colors.dart';
import '../bloc/home_bloc.dart';

/// Filter kategori horizontal yang dispatch HomeCategorySelected ke BLoC.
class HomeCategoryFilter extends StatelessWidget {
  final String selectedCategory;

  static const List<String> categories = [
    'All',
    'Shoes',
    'Apparel',
    'Men',
    'Woman',
    'Kids',
    'Sport',
  ];

  const HomeCategoryFilter({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: categories.map((cat) {
            final isActive = cat == selectedCategory;
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () =>
                    context.read<HomeBloc>().add(HomeCategorySelected(cat)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.limeGreen : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: isActive
                          ? AppColors.limeGreen
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.limeGreen.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
