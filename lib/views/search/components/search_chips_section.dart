import 'package:flutter/material.dart';
import '../../../core/models/search_models.dart';

class SearchChipsSection extends StatelessWidget {
  final List<SearchChip> chips;
  final Function(SearchChip) onChipTap;
  final EdgeInsetsGeometry? padding;

  const SearchChipsSection({
    super.key,
    required this.chips,
    required this.onChipTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (chips.any((chip) => chip.type == SearchChipType.trending))
            _buildSectionTitle('Tendencias', Icons.trending_up, Colors.orange),
          if (chips.any((chip) => chip.type == SearchChipType.recent))
            _buildSectionTitle(
              'Búsquedas recientes',
              Icons.history,
              Colors.grey,
            ),
          const SizedBox(height: 8),
          _buildChipsWrap(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipsWrap() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: chips.map((chip) => _buildChip(chip)).toList(),
    );
  }

  Widget _buildChip(SearchChip chip) {
    return Builder(
      builder: (context) {
        final chipColor = chip.color ?? chip.type.color;
        final chipIcon = chip.icon ?? chip.type.icon;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChipTap(chip),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: chipColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: chipColor.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (chip.type == SearchChipType.trending)
                    const Text('🔥 ', style: TextStyle(fontSize: 12)),
                  if (chip.type != SearchChipType.trending)
                    Icon(chipIcon, size: 14, color: chipColor),
                  if (chip.type != SearchChipType.trending)
                    const SizedBox(width: 4),
                  Text(
                    chip.text,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: chipColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget para mostrar chips categorizados
class CategorizedSearchChips extends StatelessWidget {
  final List<SearchChip> chips;
  final Function(SearchChip) onChipTap;
  final bool showSectionTitles;

  const CategorizedSearchChips({
    super.key,
    required this.chips,
    required this.onChipTap,
    this.showSectionTitles = true,
  });

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();

    final trendingChips =
        chips.where((c) => c.type == SearchChipType.trending).toList();
    final recentChips =
        chips.where((c) => c.type == SearchChipType.recent).toList();
    final categoryChips =
        chips.where((c) => c.type == SearchChipType.category).toList();
    final otherChips =
        chips
            .where(
              (c) =>
                  c.type != SearchChipType.trending &&
                  c.type != SearchChipType.recent &&
                  c.type != SearchChipType.category,
            )
            .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (trendingChips.isNotEmpty) ...[
            if (showSectionTitles) _buildSectionHeader('🔥 Tendencias'),
            _buildChipsSection(trendingChips),
            const SizedBox(height: 16),
          ],

          if (recentChips.isNotEmpty) ...[
            if (showSectionTitles) _buildSectionHeader('🕒 Recientes'),
            _buildChipsSection(recentChips),
            const SizedBox(height: 16),
          ],

          if (categoryChips.isNotEmpty) ...[
            if (showSectionTitles) _buildSectionHeader('📂 Categorías'),
            _buildChipsSection(categoryChips),
            const SizedBox(height: 16),
          ],

          if (otherChips.isNotEmpty) ...[
            if (showSectionTitles) _buildSectionHeader('⭐ Destacados'),
            _buildChipsSection(otherChips),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildChipsSection(List<SearchChip> sectionChips) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: sectionChips.map((chip) => _buildChip(chip)).toList(),
    );
  }

  Widget _buildChip(SearchChip chip) {
    return Builder(
      builder: (context) {
        final chipColor = chip.color ?? chip.type.color;
        final chipIcon = chip.icon ?? chip.type.icon;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChipTap(chip),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: chipColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: chipColor.withOpacity(0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (chip.type == SearchChipType.trending)
                    const Text('🔥 ', style: TextStyle(fontSize: 12)),
                  if (chip.type != SearchChipType.trending)
                    Icon(chipIcon, size: 14, color: chipColor),
                  if (chip.type != SearchChipType.trending)
                    const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      chip.text,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: chipColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
