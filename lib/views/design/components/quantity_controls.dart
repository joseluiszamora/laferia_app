import 'package:flutter/material.dart';

class QuantityControl extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;
  final int minQuantity;
  final int maxQuantity;

  const QuantityControl({
    Key? key,
    required this.quantity,
    required this.onQuantityChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(context, Icons.remove, () {
            if (quantity > minQuantity) {
              onQuantityChanged(quantity - 1);
            }
          }, enabled: quantity > minQuantity),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              quantity.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.textTheme.bodyLarge?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
          ),
          _buildButton(context, Icons.add, () {
            if (quantity < maxQuantity) {
              onQuantityChanged(quantity + 1);
            }
          }, enabled: quantity < maxQuantity),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    IconData icon,
    VoidCallback onPressed, {
    bool enabled = true,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: enabled ? theme.colorScheme.primary : theme.disabledColor,
          ),
        ),
      ),
    );
  }
}

class CompactQuantityControl extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;
  final VoidCallback? onRemove;

  const CompactQuantityControl({
    Key? key,
    required this.quantity,
    required this.onQuantityChanged,
    this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            if (quantity > 1) {
              onQuantityChanged(quantity - 1);
            } else if (onRemove != null) {
              onRemove!();
            }
          },
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color:
                  quantity > 1
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : Colors.red.shade100,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    quantity > 1
                        ? theme.colorScheme.primary.withOpacity(0.3)
                        : Colors.red.shade300,
              ),
            ),
            child: Icon(
              quantity > 1 ? Icons.remove : Icons.delete_outline,
              size: 16,
              color:
                  quantity > 1
                      ? theme.colorScheme.primary
                      : Colors.red.shade600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          quantity.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
            fontFamily: 'Kodchasan',
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => onQuantityChanged(quantity + 1),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: theme.colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Icon(Icons.add, size: 16, color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
