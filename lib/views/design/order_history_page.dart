import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<OrderItem> _allOrders = [
    OrderItem(
      id: "ORD-001",
      restaurantName: "Pizza Palace",
      items: ["Margherita Pizza", "Garlic Bread"],
      totalAmount: 24.50,
      status: OrderStatus.delivered,
      orderDate: DateTime.now().subtract(const Duration(days: 1)),
      deliveryDate: DateTime.now().subtract(const Duration(days: 1, hours: 1)),
    ),
    OrderItem(
      id: "ORD-002",
      restaurantName: "Burger House",
      items: ["Chicken Burger", "French Fries", "Coke"],
      totalAmount: 18.99,
      status: OrderStatus.inProgress,
      orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      estimatedDelivery: DateTime.now().add(const Duration(minutes: 30)),
    ),
    OrderItem(
      id: "ORD-003",
      restaurantName: "Healthy Bites",
      items: ["Caesar Salad", "Smoothie"],
      totalAmount: 15.75,
      status: OrderStatus.cancelled,
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
      cancelReason: "Restaurant was closed",
    ),
    OrderItem(
      id: "ORD-004",
      restaurantName: "Sushi Express",
      items: ["California Roll", "Miso Soup", "Edamame"],
      totalAmount: 32.00,
      status: OrderStatus.delivered,
      orderDate: DateTime.now().subtract(const Duration(days: 7)),
      deliveryDate: DateTime.now().subtract(const Duration(days: 7, hours: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.textTheme.titleMedium?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Order History",
          style: TextStyle(
            color: theme.textTheme.headlineMedium?.color,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kodchasan',
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.textTheme.bodyMedium?.color,
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Delivered"),
            Tab(text: "In Progress"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(_allOrders, theme),
          _buildOrdersList(_getOrdersByStatus(OrderStatus.delivered), theme),
          _buildOrdersList(_getOrdersByStatus(OrderStatus.inProgress), theme),
          _buildOrdersList(_getOrdersByStatus(OrderStatus.cancelled), theme),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderItem> orders, ThemeData theme) {
    if (orders.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OrderCard(
          order: order,
          theme: theme,
          onTap: () => _showOrderDetails(order),
          onReorder: () => _reorderItems(order),
          onTrack: () => _trackOrder(order),
          onCancel: () => _cancelOrder(order),
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No orders found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your order history will appear here",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
        ],
      ),
    );
  }

  List<OrderItem> _getOrdersByStatus(OrderStatus status) {
    return _allOrders.where((order) => order.status == status).toList();
  }

  void _showOrderDetails(OrderItem order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _OrderDetailsSheet(order: order),
    );
  }

  void _reorderItems(OrderItem order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Reordering items from ${order.restaurantName}")),
    );
  }

  void _trackOrder(OrderItem order) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Tracking order ${order.id}")));
  }

  void _cancelOrder(OrderItem order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Cancel Order"),
            content: Text("Are you sure you want to cancel this order?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    order.status = OrderStatus.cancelled;
                    order.cancelReason = "Cancelled by user";
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Order cancelled")),
                  );
                },
                child: Text("Yes", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderItem order;
  final ThemeData theme;
  final VoidCallback onTap;
  final VoidCallback onReorder;
  final VoidCallback onTrack;
  final VoidCallback onCancel;

  const _OrderCard({
    required this.order,
    required this.theme,
    required this.onTap,
    required this.onReorder,
    required this.onTrack,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.restaurantName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleMedium?.color,
                              fontFamily: 'Kodchasan',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.id,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodySmall?.color,
                              fontFamily: 'Kodchasan',
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(),
                  ],
                ),

                const SizedBox(height: 12),

                // Items
                Text(
                  order.items.join(" • "),
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color,
                    fontFamily: 'Kodchasan',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),

                // Amount and date
                Row(
                  children: [
                    Text(
                      "\$${order.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDate(order.orderDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                  ],
                ),

                // Status specific information
                if (order.status == OrderStatus.inProgress &&
                    order.estimatedDelivery != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Estimated delivery: ${_formatTime(order.estimatedDelivery!)}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade600,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Kodchasan',
                    ),
                  ),
                ],

                if (order.status == OrderStatus.cancelled &&
                    order.cancelReason != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    "Reason: ${order.cancelReason}",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade600,
                      fontFamily: 'Kodchasan',
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Action buttons
                Row(
                  children: [
                    if (order.status == OrderStatus.inProgress) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onTrack,
                          child: Text("Track Order"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red.shade300),
                          ),
                          child: Text("Cancel"),
                        ),
                      ),
                    ] else if (order.status == OrderStatus.delivered) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReorder,
                          child: Text("Reorder"),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(onPressed: () {}, child: Text("Rate")),
                    ] else if (order.status == OrderStatus.cancelled) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReorder,
                          child: Text("Order Again"),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (order.status) {
      case OrderStatus.delivered:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        text = "Delivered";
        break;
      case OrderStatus.inProgress:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        text = "In Progress";
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        text = "Cancelled";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: 'Kodchasan',
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return "$displayHour:$minute $period";
  }
}

class _OrderDetailsSheet extends StatelessWidget {
  final OrderItem order;

  const _OrderDetailsSheet({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Details",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 20),

          _buildDetailRow("Order ID", order.id),
          _buildDetailRow("Restaurant", order.restaurantName),
          _buildDetailRow("Items", order.items.join(", ")),
          _buildDetailRow(
            "Total Amount",
            "\$${order.totalAmount.toStringAsFixed(2)}",
          ),
          _buildDetailRow("Order Date", _formatFullDate(order.orderDate)),

          if (order.deliveryDate != null)
            _buildDetailRow("Delivered", _formatFullDate(order.deliveryDate!)),

          if (order.estimatedDelivery != null)
            _buildDetailRow(
              "Estimated Delivery",
              _formatFullDate(order.estimatedDelivery!),
            ),

          if (order.cancelReason != null)
            _buildDetailRow("Cancel Reason", order.cancelReason!),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Kodchasan',
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontFamily: 'Kodchasan')),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} at ${_formatTime(date)}";
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return "$displayHour:$minute $period";
  }
}

enum OrderStatus { delivered, inProgress, cancelled }

class OrderItem {
  final String id;
  final String restaurantName;
  final List<String> items;
  final double totalAmount;
  OrderStatus status;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final DateTime? estimatedDelivery;
  String? cancelReason;

  OrderItem({
    required this.id,
    required this.restaurantName,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
    this.estimatedDelivery,
    this.cancelReason,
  });
}
