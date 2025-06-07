import 'package:flutter/material.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int _selectedPaymentMethod = 0;

  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(
      id: "1",
      type: PaymentType.card,
      name: "Credit Card",
      details: "**** **** **** 1234",
      icon: Icons.credit_card,
      isDefault: true,
    ),
    PaymentMethod(
      id: "2",
      type: PaymentType.card,
      name: "Debit Card",
      details: "**** **** **** 5678",
      icon: Icons.credit_card,
      isDefault: false,
    ),
    PaymentMethod(
      id: "3",
      type: PaymentType.digital,
      name: "PayPal",
      details: "john.doe@email.com",
      icon: Icons.payment,
      isDefault: false,
    ),
    PaymentMethod(
      id: "4",
      type: PaymentType.cash,
      name: "Cash on Delivery",
      details: "Pay when you receive",
      icon: Icons.money,
      isDefault: false,
    ),
  ];

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
          "Payment Methods",
          style: TextStyle(
            color: theme.textTheme.headlineMedium?.color,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kodchasan',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: theme.colorScheme.primary),
            onPressed: () => _showAddPaymentMethodDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _paymentMethods.length,
              itemBuilder: (context, index) {
                final method = _paymentMethods[index];
                final isSelected = _selectedPaymentMethod == index;

                return _PaymentMethodCard(
                  method: method,
                  theme: theme,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = index;
                    });
                  },
                  onEdit: () => _editPaymentMethod(method),
                  onDelete: () => _deletePaymentMethod(index),
                  onSetDefault: () => _setDefaultPaymentMethod(index),
                );
              },
            ),
          ),

          // Add new payment method button
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SecondaryButton(
                  text: "Add New Payment Method",
                  icon: Icons.add,
                  onPressed: () => _showAddPaymentMethodDialog(),
                  margin: EdgeInsets.zero,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: "Continue",
                  onPressed: () => _proceedWithSelectedMethod(),
                  margin: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentMethodDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AddPaymentMethodSheet(),
    );
  }

  void _editPaymentMethod(PaymentMethod method) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Edit ${method.name}")));
  }

  void _deletePaymentMethod(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete Payment Method"),
            content: Text(
              "Are you sure you want to delete this payment method?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _paymentMethods.removeAt(index);
                    if (_selectedPaymentMethod >= _paymentMethods.length) {
                      _selectedPaymentMethod = _paymentMethods.length - 1;
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Payment method deleted")),
                  );
                },
                child: Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  void _setDefaultPaymentMethod(int index) {
    setState(() {
      // Remove default from all methods
      for (var method in _paymentMethods) {
        method.isDefault = false;
      }
      // Set new default
      _paymentMethods[index].isDefault = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Default payment method updated")),
    );
  }

  void _proceedWithSelectedMethod() {
    final selectedMethod = _paymentMethods[_selectedPaymentMethod];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Proceeding with ${selectedMethod.name}")),
    );
    Navigator.pop(context);
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final PaymentMethod method;
  final ThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _PaymentMethodCard({
    required this.method,
    required this.theme,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                color:
                    isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getMethodColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        method.icon,
                        color: _getMethodColor(),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                method.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: theme.textTheme.titleMedium?.color,
                                  fontFamily: 'Kodchasan',
                                ),
                              ),
                              if (method.isDefault) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Default",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                      fontFamily: 'Kodchasan',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            method.details,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color,
                              fontFamily: 'Kodchasan',
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                        size: 24,
                      )
                    else
                      Icon(
                        Icons.radio_button_unchecked,
                        color: theme.colorScheme.outline,
                        size: 24,
                      ),
                  ],
                ),

                if (method.type != PaymentType.cash) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (!method.isDefault)
                        TextButton(
                          onPressed: onSetDefault,
                          child: Text(
                            "Set as Default",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Kodchasan',
                            ),
                          ),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: onEdit,
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: onDelete,
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getMethodColor() {
    switch (method.type) {
      case PaymentType.card:
        return Colors.blue;
      case PaymentType.digital:
        return Colors.purple;
      case PaymentType.cash:
        return Colors.green;
    }
  }
}

class _AddPaymentMethodSheet extends StatefulWidget {
  @override
  State<_AddPaymentMethodSheet> createState() => _AddPaymentMethodSheetState();
}

class _AddPaymentMethodSheetState extends State<_AddPaymentMethodSheet> {
  int _selectedType = 0;
  final List<String> _paymentTypes = [
    "Credit Card",
    "Debit Card",
    "PayPal",
    "Apple Pay",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Payment Method",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 20),

          Text(
            "Select payment type",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 12),

          ...List.generate(_paymentTypes.length, (index) {
            final isSelected = _selectedType == index;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color:
                        isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                leading: Radio<int>(
                  value: index,
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                title: Text(
                  _paymentTypes[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Kodchasan',
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedType = index;
                  });
                },
              ),
            );
          }),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: "Cancel",
                  onPressed: () => Navigator.pop(context),
                  margin: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: "Continue",
                  onPressed: () {
                    Navigator.pop(context);
                    _showPaymentDetailsForm();
                  },
                  margin: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showPaymentDetailsForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Navigate to ${_paymentTypes[_selectedType]} details form",
        ),
      ),
    );
  }
}

enum PaymentType { card, digital, cash }

class PaymentMethod {
  final String id;
  final PaymentType type;
  final String name;
  final String details;
  final IconData icon;
  bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    required this.details,
    required this.icon,
    required this.isDefault,
  });
}
