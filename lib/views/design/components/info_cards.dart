import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color? iconColor;
  final VoidCallback? onTap;

  const InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (iconColor ?? theme.colorScheme.primary).withOpacity(
                    0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.titleMedium?.color,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color,
                        fontFamily: 'Kodchasan',
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: theme.textTheme.bodySmall?.color,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;

  const QuickActionCard({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (backgroundColor ?? theme.colorScheme.primary).withOpacity(
              0.2,
            ),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor ?? theme.colorScheme.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor ?? theme.colorScheme.primary,
                fontFamily: 'Kodchasan',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final List<SummaryItem> items;
  final Widget? bottomWidget;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.items,
    this.bottomWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.headlineMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _buildSummaryItem(context, item)),
          if (bottomWidget != null) ...[
            const SizedBox(height: 16),
            bottomWidget!,
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, SummaryItem item) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.label,
            style: TextStyle(
              fontSize: item.isTotal ? 16 : 14,
              fontWeight: item.isTotal ? FontWeight.bold : FontWeight.normal,
              color: theme.textTheme.bodyMedium?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
          Text(
            item.value,
            style: TextStyle(
              fontSize: item.isTotal ? 16 : 14,
              fontWeight: item.isTotal ? FontWeight.bold : FontWeight.w600,
              color:
                  item.isTotal
                      ? theme.colorScheme.primary
                      : theme.textTheme.bodyLarge?.color,
              fontFamily: 'Kodchasan',
            ),
          ),
        ],
      ),
    );
  }
}

class SummaryItem {
  final String label;
  final String value;
  final bool isTotal;

  const SummaryItem({
    required this.label,
    required this.value,
    this.isTotal = false,
  });
}
