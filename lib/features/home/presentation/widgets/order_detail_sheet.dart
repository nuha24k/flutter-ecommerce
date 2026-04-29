import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/colors.dart';

/// Bottom sheet overlay untuk detail order.
/// Mirip dengan PaymentMethodPage di cart_page.dart.
/// Untuk order Shipping, menampilkan shipping tracker timeline.
class OrderDetailSheet extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailSheet({super.key, required this.order});

  static void show(BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) =>
            OrderDetailSheet(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = order['items'] as List<Map<String, dynamic>>;
    final totalAmount = order['totalAmount'] as double;
    final date = order['date'] as DateTime;
    final status = order['status'] as String;
    final isShipping = status == 'Shipping';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ${order['id']}',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a').format(date),
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                _StatusBadge(status: status),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Divider(color: Colors.grey.shade100, height: 1),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping tracker (hanya untuk order Shipping)
                  if (isShipping) ...[
                    _ShippingTracker(),
                    const SizedBox(height: 28),
                  ],

                  // Items
                  const Text(
                    'Order Items',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...items.map((item) => _OrderItemRow(item: item)),

                  const SizedBox(height: 20),

                  // Summary box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Subtotal',
                          value:
                              '\$${totalAmount.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 10),
                        _SummaryRow(label: 'Shipping', value: 'Free'),
                        const SizedBox(height: 10),
                        _SummaryRow(label: 'Tax', value: '\$0.00'),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Divider(
                              color: Colors.grey.shade300, height: 1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                            Text(
                              '\$${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Shipping address
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.grey.shade200, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.cobaltBlue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.cobaltBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Shipping Address',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF9E9E9E),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Jl. Sudirman No. 12, Jakarta Pusat\nDKI Jakarta, 10210',
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1A2E),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Action button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.cobaltBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'Paid';
    final bg = isPaid
        ? AppColors.limeGreen.withValues(alpha: 0.2)
        : Colors.orange.withValues(alpha: 0.15);
    final color = isPaid ? const Color(0xFF1A6B2A) : Colors.orange.shade700;
    final icon = isPaid ? Icons.check_circle_rounded : Icons.local_shipping_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shipping Tracker Timeline ────────────────────────────────
class _ShippingTracker extends StatelessWidget {
  static const _steps = [
    (Icons.receipt_long_rounded, 'Order Placed', 'Your order has been confirmed', true),
    (Icons.verified_rounded, 'Payment Confirmed', 'Payment successfully received', true),
    (Icons.inventory_2_rounded, 'Processing', 'Your items are being prepared', true),
    (Icons.local_shipping_rounded, 'Shipped', 'Package is on the way', true),
    (Icons.delivery_dining_rounded, 'Out for Delivery', 'Driver is heading to you', false),
    (Icons.home_rounded, 'Delivered', 'Package delivered successfully', false),
  ];

  const _ShippingTracker();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Shipping Status',
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded,
                  color: Colors.orange.shade700, size: 13),
              const SizedBox(width: 5),
              Text(
                'Estimated delivery: May 2, 2026',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ..._steps.asMap().entries.map((entry) {
          final i = entry.key;
          final (icon, title, subtitle, done) = entry.value;
          final isLast = i == _steps.length - 1;
          final isActive = done && (i + 1 < _steps.length && !_steps[i + 1].$4);

          return _TrackStep(
            icon: icon,
            title: title,
            subtitle: subtitle,
            isDone: done,
            isActive: isActive,
            isLast: isLast,
          );
        }),
      ],
    );
  }
}

class _TrackStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDone;
  final bool isActive;
  final bool isLast;

  const _TrackStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.isActive,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Color iconColor;
    Color bgColor;

    if (isDone) {
      dotColor = AppColors.cobaltBlue;
      iconColor = Colors.white;
      bgColor = AppColors.cobaltBlue;
    } else if (isActive) {
      dotColor = Colors.orange;
      iconColor = Colors.white;
      bgColor = Colors.orange;
    } else {
      dotColor = Colors.grey.shade300;
      iconColor = Colors.grey.shade400;
      bgColor = Colors.grey.shade100;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: dot + line
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                  boxShadow: isDone || isActive
                      ? [
                          BoxShadow(
                            color: dotColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : [],
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 36,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.cobaltBlue.withValues(alpha: 0.3)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        // Right: text
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: isDone || isActive
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isDone || isActive
                        ? const Color(0xFF1A1A2E)
                        : Colors.grey.shade400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Order Item Row ───────────────────────────────────────────
class _OrderItemRow extends StatelessWidget {
  final Map<String, dynamic> item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final product = item['product'];
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: product.bgColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                product.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  product.brand,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    _Chip('Size ${item['size']}'),
                    const SizedBox(width: 6),
                    _Chip(item['color']),
                    const SizedBox(width: 6),
                    _Chip('Qty ${item['quantity']}'),
                  ],
                ),
              ],
            ),
          ),
          Text(
            product.price,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }
}

// ─── Summary Row ─────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}
