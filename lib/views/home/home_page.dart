import 'package:flutter/material.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _bannerController = PageController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _bannerTimer;
  int _currentBannerIndex = 0;

  final List<BannerItem> _banners = [
    BannerItem(
      title: "Happy Sunday",
      subtitle: "Get 50%+ Discount!",
      buttonText: "Get Now",
      backgroundColor: Color(0xFFFF8C69),
      imageUrl: "🥝", // Placeholder emoji
    ),
    BannerItem(
      title: "Fresh Fruits",
      subtitle: "Healthy & Delicious",
      buttonText: "Order Now",
      backgroundColor: Color(0xFF4CAF50),
      imageUrl: "🍓",
    ),
    BannerItem(
      title: "Pizza Special",
      subtitle: "Buy 1 Get 1 Free",
      buttonText: "Order",
      backgroundColor: Color(0xFFFF6B35),
      imageUrl: "🍕",
    ),
  ];

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

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_banners.isNotEmpty) {
        _currentBannerIndex = (_currentBannerIndex + 1) % _banners.length;
        if (_bannerController.hasClients) {
          _bannerController.animateToPage(
            _currentBannerIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      // TODO: Implement actual search functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Searching for: "$query"'),
          action: SnackBarAction(
            label: 'View Results',
            onPressed: () {
              // Navigate to search results
            },
          ),
        ),
      );
    }
  }

  void _showSearchFilters() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search Filters",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headlineMedium?.color,
                    fontFamily: 'Kodchasan',
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.location_on),
                  title: const Text("Nearby restaurants"),
                  onTap: () {
                    Navigator.pop(context);
                    _filterByLocation();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text("Highly rated"),
                  onTap: () {
                    Navigator.pop(context);
                    _filterByRating();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.local_offer),
                  title: const Text("Special offers"),
                  onTap: () {
                    Navigator.pop(context);
                    _filterByOffers();
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _filterByLocation() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Showing nearby restaurants')));
  }

  void _filterByRating() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Showing highly rated restaurants')),
    );
  }

  void _filterByOffers() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Showing special offers')));
  }

  void _navigateToCategory(String category) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigating to $category category')));
  }

  void _navigateToBannerOffer(BannerItem banner) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opening offer: ${banner.title}')));
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
              _buildWelcomeSection(theme),
              const SizedBox(height: 24),

              // Search bar
              _buildSearchBar(theme),
              const SizedBox(height: 24),

              // Banner section
              _buildBannerSection(theme),
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

  Widget _buildWelcomeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Providing the best",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.headlineMedium?.color,
            fontFamily: 'Kodchasan',
          ),
        ),
        Row(
          children: [
            Text(
              "foods for you! ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.headlineMedium?.color,
                fontFamily: 'Kodchasan',
              ),
            ),
            Text("😋", style: TextStyle(fontSize: 24)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: _performSearch,
        decoration: InputDecoration(
          hintText: "Search for restaurants, food...",
          hintStyle: TextStyle(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            fontFamily: 'Kodchasan',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
          suffixIcon: GestureDetector(
            onTap: _showSearchFilters,
            child: Icon(Icons.tune, color: theme.colorScheme.primary),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontSize: 16,
          fontFamily: 'Kodchasan',
        ),
      ),
    );
  }

  Widget _buildBannerSection(ThemeData theme) {
    return SizedBox(
      height: 170,
      child: PageView.builder(
        controller: _bannerController,
        onPageChanged: (index) {
          setState(() {
            _currentBannerIndex = index;
          });
        },
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final banner = _banners[index];
          return Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: banner.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: banner.backgroundColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          banner.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _navigateToBannerOffer(banner),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black.withOpacity(0.3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                banner.buttonText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Kodchasan',
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        banner.imageUrl,
                        style: const TextStyle(fontSize: 60),
                      ),
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
class BannerItem {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color backgroundColor;
  final String imageUrl;

  BannerItem({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.backgroundColor,
    required this.imageUrl,
  });
}

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
