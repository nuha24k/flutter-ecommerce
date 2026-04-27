import 'package:flutter/material.dart';

/// Empty state yang ditampilkan ketika tidak ada order di tab tertentu.
class OrderEmptyState extends StatelessWidget {
  /// Label tab yang aktif ('Paid' atau 'Shipping').
  final String tabStatus;

  const OrderEmptyState({super.key, required this.tabStatus});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            tabStatus == 'Paid'
                ? Icons.receipt_long_outlined
                : Icons.local_shipping_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No $tabStatus Orders Yet',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When you place an order, it will appear here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 14,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
