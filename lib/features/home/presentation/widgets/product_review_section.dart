import 'package:flutter/material.dart';
import '../../../../../core/constants/colors.dart';

/// Seksi review pelanggan: rating summary + daftar review cards.
class ProductReviewSection extends StatelessWidget {
  final double rating;
  final List<Map<String, dynamic>> reviews;

  const ProductReviewSection({
    super.key,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 18,
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
        ),
        const SizedBox(height: 14),
        // Rating Summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A1A2E),
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(5, (i) {
                        final full = i < rating.floor();
                        return Icon(
                          full
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: const Color(0xFFFFB800),
                          size: 14,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '248 ulasan',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                // Rating bars
                Expanded(
                  child: Column(
                    children: List.generate(5, (i) {
                      final star = 5 - i;
                      final pct = [0.78, 0.14, 0.05, 0.02, 0.01][i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text(
                              '$star',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star_rounded,
                                color: Color(0xFFFFB800), size: 10),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: Colors.grey.shade100,
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                    Color(0xFFFFB800),
                                  ),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        // Review cards
        ...reviews.map((r) => _ReviewCard(review: r)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.cobaltBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    review['avatar'] as String,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review['name'] as String,
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        if (review['verified'] as bool) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.verified_rounded,
                                    color: Colors.green.shade600, size: 10),
                                const SizedBox(width: 3),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      review['date'] as String,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  review['rating'] as int,
                  (_) => const Icon(Icons.star_rounded,
                      color: Color(0xFFFFB800), size: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'] as String,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
