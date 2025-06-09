import 'package:flutter/material.dart';

import 'package:laferia/views/home/components/banner_section.dart';
import 'package:laferia/views/home/components/search_section.dart';
import 'package:laferia/views/home/components/welcome_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<CategoryItem> _categories = [
    CategoryItem(name: "Burger", emoji: "🍔", isPopular: true),
    CategoryItem(name: "Hot Dog", emoji: "🌭", isPopular: false),
    CategoryItem(name: "Pizza", emoji: "🍕", isPopular: true),
    CategoryItem(name: "Sushi", emoji: "🍣", isPopular: false),
    CategoryItem(name: "Drinks", emoji: "🥤", isPopular: false),
  ];

  final List<FoodItem> _recommendedItems = [
    FoodItem(
      id: "1",
      name: "Caesar Salad",
      price: 12.99,
      rating: 4.8,
      imageUrl: "🥗",
      isFavorite: false,
      restaurant: "Healthy Bites",
    ),
    FoodItem(
      id: "2",
      name: "Pasta Carbonara",
      price: 15.50,
      rating: 4.9,
      imageUrl: "🍝",
      isFavorite: true,
      restaurant: "Italian Corner",
    ),
    FoodItem(
      id: "3",
      name: "Grilled Chicken",
      price: 18.75,
      rating: 4.7,
      imageUrl: "🍗",
      isFavorite: false,
      restaurant: "Grill Master",
    ),
    FoodItem(
      id: "4",
      name: "Vegetable Bowl",
      price: 14.25,
      rating: 4.6,
      imageUrl: "🥙",
      isFavorite: true,
      restaurant: "Green Garden",
    ),
  ];

  void _navigateToCategory(String category) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigating to $category category')));
  }

  void _navigateToNearbyRestaurants() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Finding nearby restaurants...'),
        action: SnackBarAction(label: 'View Map', onPressed: () {}),
      ),
    );
  }

  void _navigateToOffers() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading today\'s special offers...'),
        action: SnackBarAction(label: 'View All', onPressed: () {}),
      ),
    );
  }

  void _navigateToAllCategories() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing all food categories...'),
        action: SnackBarAction(label: 'Filter', onPressed: () {}),
      ),
    );
  }

  void _navigateToAllRecommended() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Showing all recommended items...'),
        action: SnackBarAction(label: 'Sort', onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              WelcomeSection(),
              const SizedBox(height: 24),

              // Search bar
              SearchSection(),
              const SizedBox(height: 24),

              // Banner section
              BannerSection(),
              const SizedBox(height: 32),

              // Categories section
              _buildCategoriesSection(theme),
              const SizedBox(height: 32),

              // Recommended section
              _buildRecommendedSection(theme),
              const SizedBox(height: 32),

              // Quick actions section
              _buildQuickActionsSection(theme),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Find by category",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
            TextButton(
              onPressed: () => _navigateToAllCategories(),
              child: Text(
                "See All",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Kodchasan',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Container(
                width: 80,
                margin: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => _navigateToCategory(category.name),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color:
                              category.isPopular
                                  ? theme.colorScheme.primary.withOpacity(0.1)
                                  : theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                category.isPopular
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline.withOpacity(
                                      0.3,
                                    ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            category.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodyMedium?.color,
                          fontFamily: 'Kodchasan',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recommended for you",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
            TextButton(
              onPressed: () => _navigateToAllRecommended(),
              child: Text(
                "See All",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Kodchasan',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _recommendedItems.length,
            itemBuilder: (context, index) {
              final item = _recommendedItems[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              item.imageUrl,
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.isFavorite = !item.isFavorite;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  item.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      item.isFavorite
                                          ? Colors.red
                                          : Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content section
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleMedium?.color,
                              fontFamily: 'Kodchasan',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.restaurant,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodySmall?.color,
                              fontFamily: 'Kodchasan',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${item.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                  fontFamily: 'Kodchasan',
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    item.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: theme.textTheme.bodySmall?.color,
                                      fontFamily: 'Kodchasan',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineMedium?.color,
            fontFamily: 'Kodchasan',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                theme,
                Icons.location_on,
                "Nearby\nRestaurants",
                theme.colorScheme.primary,
                () => _navigateToNearbyRestaurants(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                theme,
                Icons.local_offer,
                "Today's\nOffers",
                Colors.orange,
                () => _navigateToOffers(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    ThemeData theme,
    IconData icon,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyMedium?.color,
                  fontFamily: 'Kodchasan',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data models
class CategoryItem {
  final String name;
  final String emoji;
  final bool isPopular;

  CategoryItem({
    required this.name,
    required this.emoji,
    required this.isPopular,
  });
}

class FoodItem {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String imageUrl;
  final String restaurant;
  bool isFavorite;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.restaurant,
    required this.isFavorite,
  });
}
