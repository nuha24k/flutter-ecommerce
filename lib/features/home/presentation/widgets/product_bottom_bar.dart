import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/colors.dart';
import '../../data/models/product_item.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/product_detail_bloc.dart';

/// Bottom bar di halaman product detail: tombol Add to Cart.
class ProductBottomBar extends StatelessWidget {
  final ProductItem product;
  final ProductDetailState state;

  const ProductBottomBar({
    super.key,
    required this.product,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                context.read<CartBloc>().add(CartItemAdded({
                  'product': product,
                  'quantity': state.quantity,
                  'size': state.selectedSize,
                  'color': state.selectedColor,
                }));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('${product.name} ditambahkan ke keranjang!'),
                    backgroundColor: AppColors.cobaltBlue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  ),
                );
              },
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.cobaltBlue,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cobaltBlue.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.limeGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
