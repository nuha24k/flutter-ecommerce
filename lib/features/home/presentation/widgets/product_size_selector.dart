import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/colors.dart';
import '../bloc/product_detail_bloc.dart';

/// Selector ukuran produk (shoes: angka, apparel: S/M/L dll).
/// Dispatch ProductDetailSizeSelected ke ProductDetailBloc.
class ProductSizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;

  const ProductSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Size',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Size Guide',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.cobaltBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: sizes.map((size) {
              final isSelected = size == selectedSize;
              return GestureDetector(
                onTap: () => context
                    .read<ProductDetailBloc>()
                    .add(ProductDetailSizeSelected(size)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.cobaltBlue : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.cobaltBlue
                          : Colors.grey.shade200,
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.cobaltBlue
                                  .withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      size,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
