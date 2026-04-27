import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/colors.dart';
import '../bloc/product_detail_bloc.dart';

/// Quantity stepper (+/-) yang dispatch ProductDetailQuantityUpdated ke BLoC.
class ProductQuantitySelector extends StatelessWidget {
  final int quantity;

  const ProductQuantitySelector({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'Quantity',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Row(
              children: [
                _QtyButton(
                  icon: Icons.remove_rounded,
                  onTap: () {
                    if (quantity > 1) {
                      context
                          .read<ProductDetailBloc>()
                          .add(ProductDetailQuantityUpdated(quantity - 1));
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),
                _QtyButton(
                  icon: Icons.add_rounded,
                  onTap: () => context
                      .read<ProductDetailBloc>()
                      .add(ProductDetailQuantityUpdated(quantity + 1)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.cobaltBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
