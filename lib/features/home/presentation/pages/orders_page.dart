import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../bloc/order_bloc.dart';
import '../widgets/order_card.dart';
import '../widgets/order_empty_state.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  int _selectedTab = 0;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (index == _selectedTab) return;
    setState(() => _selectedTab = index);
    _fadeCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _buildSegmentedTabs(),
          const SizedBox(height: 4),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  final paidOrders = state.orders
                      .where((o) => o['status'] == 'Paid')
                      .toList();
                  final shippingOrders = state.orders
                      .where((o) => o['status'] == 'Shipping')
                      .toList();

                  final currentOrders =
                      _selectedTab == 0 ? paidOrders : shippingOrders;
                  final tabLabel =
                      _selectedTab == 0 ? 'Paid' : 'Shipping';

                  return _buildOrderList(currentOrders, tabLabel);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF7F8FC),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1A1A2E),
            size: 18,
          ),
        ),
      ),
      title: const Text(
        'My Orders',
        style: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1A1A2E),
        ),
      ),
      centerTitle: true,
      actions: [
        BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1400FF).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${state.orders.length} Orders',
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1400FF),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSegmentedTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          final paidCount =
              state.orders.where((o) => o['status'] == 'Paid').length;
          final shippingCount =
              state.orders.where((o) => o['status'] == 'Shipping').length;

          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _TabItem(
                  label: 'Paid',
                  count: paidCount,
                  icon: Icons.check_circle_rounded,
                  isSelected: _selectedTab == 0,
                  onTap: () => _switchTab(0),
                ),
                _TabItem(
                  label: 'Shipping',
                  count: shippingCount,
                  icon: Icons.local_shipping_rounded,
                  isSelected: _selectedTab == 1,
                  onTap: () => _switchTab(1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderList(
      List<Map<String, dynamic>> orders, String tabLabel) {
    if (orders.isEmpty) {
      return OrderEmptyState(tabStatus: tabLabel);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) => OrderCard(order: orders[index]),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.count,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  static const _activeColor = Color(0xFF1400FF);
  static const _limeGreen = Color(0xFFC8F400);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? _activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? _limeGreen : Colors.grey.shade400,
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade500,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _limeGreen.withValues(alpha: 0.25)
                        : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? _limeGreen : Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}