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
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1A1A2E), size: 20),
          onPressed: () => Navigator.of(context).pop(),
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
      ),
      body: Column(
        children: [
          // Custom TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.cobaltBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey.shade500,
              labelStyle: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Outfit',
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: 'Paid'),
                Tab(text: 'Shipping'),
              ],
              dividerColor: Colors.transparent,
            ),
          ),

          Expanded(
            child: BlocBuilder<OrderBloc, OrderState>(
              builder: (context, state) {
                final paidOrders = state.orders
                    .where((o) => o['status'] == 'Paid')
                    .toList();
                final shippingOrders = state.orders
                    .where((o) => o['status'] == 'Shipping')
                    .toList();

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOrderList(paidOrders, 'Paid'),
                    _buildOrderList(shippingOrders, 'Shipping'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(
      List<Map<String, dynamic>> orders, String tabStatus) {
    if (orders.isEmpty) {
      return OrderEmptyState(tabStatus: tabStatus);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      itemBuilder: (context, index) => OrderCard(order: orders[index]),
    );
  }
}
