import 'package:flutter/material.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<CartItem> _cartItems = [
    CartItem(
      id: "1",
      name: "Margherita Pizza",
      restaurant: "Pizza Palace",
      price: 18.50,
      quantity: 2,
      imageUrl: "",
      description: "Fresh tomatoes, mozzarella cheese, basil",
    ),
    CartItem(
      id: "2",
      name: "Chicken Burger",
      restaurant: "Burger House",
      price: 12.99,
      quantity: 1,
      imageUrl: "",
      description: "Grilled chicken, lettuce, tomato, mayo",
    ),
    CartItem(
      id: "3",
      name: "Caesar Salad",
      restaurant: "Healthy Bites",
      price: 9.75,
      quantity: 1,
      imageUrl: "",
      description: "Romaine lettuce, parmesan, croutons, caesar dressing",
    ),
  ];

  double get _subtotal {
    return _cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  double get _deliveryFee => 2.50;
  double get _serviceFee => 1.99;
  double get _total => _subtotal + _deliveryFee + _serviceFee;

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
          "My Cart",
          style: TextStyle(
            color: theme.textTheme.headlineMedium?.color,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kodchasan',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: theme.textTheme.titleMedium?.color,
            ),
            onPressed: _showClearCartDialog,
          ),
        ],
      ),
      body:
          _cartItems.isEmpty
              ? _buildEmptyCart(theme)
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return _CartItemCard(
                          item: item,
                          theme: theme,
                          onQuantityChanged: (newQuantity) {
                            setState(() {
                              if (newQuantity > 0) {
                                item.quantity = newQuantity;
                              } else {
                                _cartItems.removeAt(index);
                              }
                            });
                          },
                          onRemove: () {
                            setState(() {
                              _cartItems.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  _buildOrderSummary(theme),
                ],
              ),
    );
  }

  Widget _buildEmptyCart(ThemeData theme) {
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
              Icons.shopping_cart_outlined,
              size: 60,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add items to your cart to see them here",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: theme.textTheme.bodyMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: "Start Shopping",
            onPressed: () => Navigator.pop(context),
            margin: const EdgeInsets.symmetric(horizontal: 48),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Delivery info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Deliver to",
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                        Text(
                          "123 Main Street, City Center",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Change",
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Order summary
            _buildSummaryRow(
              theme,
              "Subtotal",
              "\$${_subtotal.toStringAsFixed(2)}",
            ),
            _buildSummaryRow(
              theme,
              "Delivery fee",
              "\$${_deliveryFee.toStringAsFixed(2)}",
            ),
            _buildSummaryRow(
              theme,
              "Service fee",
              "\$${_serviceFee.toStringAsFixed(2)}",
            ),
            const SizedBox(height: 8),
            Divider(color: theme.colorScheme.outline),
            const SizedBox(height: 8),
            _buildSummaryRow(
              theme,
              "Total",
              "\$${_total.toStringAsFixed(2)}",
              isTotal: true,
            ),
            const SizedBox(height: 24),

            PrimaryButton(
              text: "Proceed to Checkout",
              onPressed: () => _proceedToCheckout(),
              margin: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    ThemeData theme,
    String label,
    String value, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: theme.textTheme.bodyMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color:
                  isTotal
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text("Clear Cart", style: TextStyle(fontFamily: 'Kodchasan')),
          content: Text(
            "Are you sure you want to remove all items from your cart?",
            style: TextStyle(fontFamily: 'Kodchasan'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _cartItems.clear();
                });
                Navigator.pop(context);
              },
              child: Text("Clear", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _proceedToCheckout() {
    // Navigate to checkout page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Proceeding to checkout...")));
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final ThemeData theme;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.theme,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item image placeholder
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.fastfood,
                  color: theme.colorScheme.primary,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),

              // Item details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleMedium?.color,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.restaurant,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color,
                        fontFamily: 'Kodchasan',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Remove button
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Price and quantity controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${item.price.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                  fontFamily: 'Kodchasan',
                ),
              ),

              _QuantityControl(
                quantity: item.quantity,
                theme: theme,
                onChanged: onQuantityChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final ThemeData theme;
  final Function(int) onChanged;

  const _QuantityControl({
    required this.quantity,
    required this.theme,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            icon: Icons.remove,
            onPressed: () => onChanged(quantity - 1),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyMedium?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
          ),
          _buildQuantityButton(
            icon: Icons.add,
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 20, color: theme.colorScheme.primary),
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final String restaurant;
  final double price;
  int quantity;
  final String imageUrl;
  final String description;

  CartItem({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.description,
  });
}
