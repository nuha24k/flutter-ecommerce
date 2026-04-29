import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/order_bloc.dart';
import 'orders_page.dart';

// ─────────────────────────────────────────────
//  Payment Method Bottom Sheet
// ─────────────────────────────────────────────
class PaymentMethodPage extends StatelessWidget {
  final double totalAmount;

  const PaymentMethodPage({
    super.key,
    required this.totalAmount,
  });

  static const List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'Credit Card',
      'title': 'Credit Card',
      'subtitle': '**** **** **** 4242',
      'icon': Icons.credit_card_rounded,
      'color': Color(0xFFF5F5F0),
    },
    {
      'id': 'PayPal',
      'title': 'PayPal',
      'subtitle': 'user@example.com',
      'icon': Icons.paypal_rounded,
      'color': Color(0xFFE8F0FE),
    },
    {
      'id': 'Apple Pay',
      'title': 'Apple Pay',
      'subtitle': 'Connected',
      'icon': Icons.apple_rounded,
      'color': Color(0xFFF5F5F0),
    },
    {
      'id': 'Bank Transfer',
      'title': 'Bank Transfer',
      'subtitle': 'BCA •••• 9876',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFFE8F5E9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Payment Details',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: paymentMethods.length,
                  itemBuilder: (context, index) {
                    final method = paymentMethods[index];
                    final isSelected =
                        state.selectedPaymentMethod == method['id'];

                    return GestureDetector(
                      onTap: () {
                        context
                            .read<CartBloc>()
                            .add(CartPaymentMethodSelected(method['id']));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF8F9FA)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.cobaltBlue
                                : Colors.grey.shade200,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: method['color'],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                method['icon'],
                                size: 24,
                                color: AppColors.cobaltBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method['title'],
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1A1A2E),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    method['subtitle'],
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.cobaltBlue
                                      : Colors.grey.shade300,
                                  width: isSelected ? 5 : 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // ── Slide to Pay Button ──
              Container(
                padding: EdgeInsets.fromLTRB(
                    20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: _SlideToPayButton(
                  totalAmount: totalAmount,
                  onCompleted: () {
                    final cartState = context.read<CartBloc>().state;
                    context.read<OrderBloc>().add(
                      OrderAdded(
                        items: cartState.items,
                        totalAmount: totalAmount,
                      ),
                    );
                    context.read<CartBloc>().add(const CartCleared());
                    
                    final nav = Navigator.of(context);
                    nav.pop();
                    nav.push(
                      PageRouteBuilder(
                        opaque: true,
                        pageBuilder: (_, __, ___) =>
                            const PaymentSuccessScreen(),
                        transitionsBuilder: (_, animation, __, child) =>
                            FadeTransition(opacity: animation, child: child),
                        transitionDuration:
                            const Duration(milliseconds: 500),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SlideToPayButton extends StatefulWidget {
  final VoidCallback onCompleted;
  final double totalAmount;

  const _SlideToPayButton({
    required this.onCompleted,
    required this.totalAmount,
  });

  @override
  State<_SlideToPayButton> createState() => _SlideToPayButtonState();
}

class _SlideToPayButtonState extends State<_SlideToPayButton>
    with TickerProviderStateMixin {
  double _dragPosition = 0;
  bool _isCompleted = false;
  bool _isLoading = false;
  late AnimationController _shimmerController;
  late AnimationController _loadingController;

  static const double _thumbSize = 56;
  static const double _trackHeight = 64;
  static const double _horizontalPadding = 5;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (_isCompleted || _isLoading) return;
    setState(() {
      _dragPosition =
          (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
    });
  }

  void _onDragEnd(double maxDrag) {
    if (_isCompleted || _isLoading) return;
    if (_dragPosition >= maxDrag * 0.85) {
      setState(() {
        _dragPosition = maxDrag;
        _isCompleted = true;
        _isLoading = true;
      });
      HapticFeedback.heavyImpact();
      // Tunjukkan loading 2 detik di dalam button, lalu navigate
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) widget.onCompleted();
      });
    } else {
      setState(() => _dragPosition = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final priceText =
        '\$${widget.totalAmount.toStringAsFixed(2)}';

    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final maxDrag = trackWidth - _thumbSize - _horizontalPadding * 2;
        final progress = (_dragPosition / maxDrag).clamp(0.0, 1.0);

        // ── Loading state: full lime green button dengan spinner ──
        if (_isLoading) {
          return AnimatedBuilder(
            animation: _loadingController,
            builder: (_, __) {
              return Container(
                height: _trackHeight,
                decoration: BoxDecoration(
                  color: AppColors.limeGreen,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.limeGreen.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Processing...',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }

        // ── Normal / drag state ──
        return AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, _) {
            return Container(
              height: _trackHeight,
              decoration: BoxDecoration(
                color: AppColors.limeGreen,
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.limeGreen.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Dark fill overlay saat drag
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: (_thumbSize + _horizontalPadding * 2 +
                                  _dragPosition)
                              .clamp(0.0, trackWidth),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(
                                alpha: 0.1 * progress),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Label kiri: "Slide to Pay"
                  Positioned(
                    left: _thumbSize + _horizontalPadding * 2 + 14,
                    top: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      opacity: (1 - progress * 3).clamp(0.0, 1.0),
                      duration: Duration.zero,
                      child: Center(
                        child: Text(
                          'Slide To Pay',
                          style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Harga di kanan (fade out saat drag)
                  Positioned(
                    right: 20,
                    top: 0,
                    bottom: 0,
                    child: AnimatedOpacity(
                      opacity: (1 - progress * 2.5).clamp(0.0, 1.0),
                      duration: Duration.zero,
                      child: Center(
                        child: Text(
                          priceText,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.black.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // "Keep going" saat tengah drag
                  Center(
                    child: AnimatedOpacity(
                      opacity: progress < 0.2
                          ? 0.0
                          : progress > 0.75
                              ? 0.0
                              : ((progress - 0.2) / 0.3).clamp(0.0, 1.0),
                      duration: Duration.zero,
                      child: const Text(
                        'Almost there...',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  // Thumb (hitam, pill shape)
                  Positioned(
                    left: _horizontalPadding + _dragPosition,
                    top: _horizontalPadding,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (d) =>
                          _onDragUpdate(d, maxDrag),
                      onHorizontalDragEnd: (_) => _onDragEnd(maxDrag),
                      child: Container(
                        width: _thumbSize,
                        height: _thumbSize,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.limeGreen,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Payment Success Full-Screen Overlay
// ─────────────────────────────────────────────
class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _iconController;
  late AnimationController _contentController;
  late AnimationController _particleController;

  late Animation<double> _bgScale;
  late Animation<double> _iconScale;
  late Animation<double> _iconBounce;
  late Animation<double> _contentSlide;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _iconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _contentController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _particleController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();

    _bgScale = CurvedAnimation(
        parent: _bgController, curve: Curves.easeOutExpo);
    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _iconController, curve: Curves.elasticOut));
    _iconBounce = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _iconController, curve: Curves.bounceOut));
    _contentSlide = Tween<double>(begin: 40.0, end: 0.0).animate(
        CurvedAnimation(parent: _contentController, curve: Curves.easeOut));
    _contentFade = CurvedAnimation(
        parent: _contentController, curve: Curves.easeOut);

    _bgController.forward().then((_) {
      _iconController.forward().then((_) {
        _contentController.forward();
      });
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _iconController.dispose();
    _contentController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.cobaltBlue,
                  const Color(0xFF0D00B0),
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // Floating particles
                  ...List.generate(12, (i) => _FloatingParticle(
                        controller: _particleController,
                        index: i,
                      )),

                  // Main content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Check circle
                        ScaleTransition(
                          scale: _iconScale,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.limeGreen,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.limeGreen
                                      .withValues(alpha: 0.4),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.black,
                              size: 64,
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Text content
                        AnimatedBuilder(
                          animation: _contentController,
                          builder: (context, _) {
                            return Transform.translate(
                              offset: Offset(0, _contentSlide.value),
                              child: Opacity(
                                opacity: _contentFade.value,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Payment Successful!',
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Your order has been placed\nand is being processed.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white
                                            .withValues(alpha: 0.7),
                                        height: 1.5,
                                      ),
                                    ),
                                    const SizedBox(height: 48),

                                    // Order ID card
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(24),
                                        border: Border.all(
                                          color: Colors.white
                                              .withValues(alpha: 0.15),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _InfoTile(
                                            label: 'Order ID',
                                            value: '#MZ-8821',
                                          ),
                                          Container(
                                            width: 1,
                                            height: 40,
                                            color: Colors.white
                                                .withValues(alpha: 0.2),
                                          ),
                                          _InfoTile(
                                            label: 'Status',
                                            value: 'Confirmed',
                                            valueColor:
                                                AppColors.limeGreen,
                                          ),
                                          Container(
                                            width: 1,
                                            height: 40,
                                            color: Colors.white
                                                .withValues(alpha: 0.2),
                                          ),
                                          _InfoTile(
                                            label: 'ETA',
                                            value: '3–5 Days',
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 48),

                                    // Back to Home button
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Pop all the way back to home
                                          Navigator.of(context)
                                              .popUntil((r) => r.isFirst);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: AppColors.limeGreen,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.limeGreen
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 20,
                                                offset:
                                                    const Offset(0, 8),
                                              ),
                                            ],
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Back to Home',
                                              style: TextStyle(
                                                fontFamily: 'Outfit',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Track Order
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).popUntil((r) => r.isFirst);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const OrdersPage()),
                                        );
                                      },
                                      child: Text(
                                        'Track My Order →',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white
                                              .withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Helper: Info Tile
// ─────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Helper: Floating Particle
// ─────────────────────────────────────────────
class _FloatingParticle extends StatelessWidget {
  final AnimationController controller;
  final int index;

  const _FloatingParticle({required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    final random = math.Random(index * 31);
    final size = random.nextDouble() * 10 + 4;
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final duration = random.nextDouble() * 0.4 + 0.6;
    final delay = random.nextDouble();
    final isLime = index % 3 == 0;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = ((controller.value - delay) % 1.0 + 1.0) % 1.0;
        final easedT = t < duration ? t / duration : 1.0;
        final top = MediaQuery.of(context).size.height * (1 - easedT * 1.2);
        final opacity = easedT < 0.1
            ? easedT * 10
            : easedT > 0.8
                ? (1 - easedT) * 5
                : 1.0;

        return Positioned(
          left: left + math.sin(easedT * math.pi * 2) * 20,
          top: top,
          child: Opacity(
            opacity: opacity.clamp(0.0, 0.6),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: index % 2 == 0
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                color: isLime
                    ? AppColors.limeGreen
                    : Colors.white.withValues(alpha: 0.6),
                borderRadius:
                    index % 2 != 0 ? BorderRadius.circular(2) : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
