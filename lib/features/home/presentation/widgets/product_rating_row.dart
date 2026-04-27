import 'package:flutter/material.dart';
import '../../data/models/product_item.dart';

/// Baris rating produk: badge bintang, jumlah review, dan status stok.
class ProductRatingRow extends StatelessWidget {
  final ProductItem product;

  const ProductRatingRow({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB800).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: Color(0xFFFFB800), size: 14),
                const SizedBox(width: 4),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '(248 reviews)',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded,
                    color: Colors.green.shade600, size: 13),
                const SizedBox(width: 4),
                Text(
                  'In Stock',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
