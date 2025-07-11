import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laferia/core/routes/app_routes.dart';
import 'package:laferia/views/design/components/custom_buttons.dart';

class CuisineSelectionPage extends StatefulWidget {
  const CuisineSelectionPage({Key? key}) : super(key: key);

  @override
  State<CuisineSelectionPage> createState() => _CuisineSelectionPageState();
}

class _CuisineSelectionPageState extends State<CuisineSelectionPage> {
  final Set<String> _selectedCuisines = {};
  bool _isLoading = false;

  final List<CuisineItem> _cuisines = [
    CuisineItem(name: "Italian", emoji: "🍝"),
    CuisineItem(name: "Asian", emoji: "🍜"),
    CuisineItem(name: "Pizza", emoji: "🍕"),
    CuisineItem(name: "Burger", emoji: "🍔"),
    CuisineItem(name: "Salad", emoji: "🥗"),
    CuisineItem(name: "Dessert", emoji: "🍰"),
    CuisineItem(name: "Bakery", emoji: "🥖"),
    CuisineItem(name: "Drinks", emoji: "🥤"),
    CuisineItem(name: "Mexican", emoji: "🌮"),
    CuisineItem(name: "Indian", emoji: "🍛"),
    CuisineItem(name: "Japanese", emoji: "🍣"),
    CuisineItem(name: "Thai", emoji: "🍲"),
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
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your preferred cuisine",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.headlineMedium?.color,
                      fontFamily: 'Kodchasan',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Don't worry! You can always change this later.",
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.textTheme.bodyMedium?.color,
                      fontFamily: 'Kodchasan',
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for something...",
                        hintStyle: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontFamily: 'Kodchasan',
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Categories grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _cuisines.length,
                  itemBuilder: (context, index) {
                    final cuisine = _cuisines[index];
                    final isSelected = _selectedCuisines.contains(cuisine.name);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedCuisines.remove(cuisine.name);
                          } else {
                            _selectedCuisines.add(cuisine.name);
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? theme.colorScheme.primary.withOpacity(0.1)
                                  : theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color:
                                isSelected
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cuisine.emoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              cuisine.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? theme.colorScheme.primary
                                        : theme.textTheme.titleMedium?.color,
                                fontFamily: 'Kodchasan',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Skip button
                  SecondaryButton(
                    text: "Skip",
                    onPressed: () => _handleSkip(),
                    margin: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  // Next button
                  PrimaryButton(
                    text: "Next",
                    isLoading: _isLoading,
                    onPressed:
                        _selectedCuisines.isNotEmpty ? _handleNext : null,
                    margin: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSkip() {
    context.push(AppRoutes.locationSetup);
  }

  void _handleNext() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate saving preferences
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    context.push(AppRoutes.locationSetup);
  }
}

class CuisineItem {
  final String name;
  final String emoji;

  CuisineItem({required this.name, required this.emoji});
}
