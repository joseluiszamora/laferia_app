import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laferia/core/routes/app_routes.dart';

class DesignPagesPage extends StatelessWidget {
  const DesignPagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Design Pages",
          style: TextStyle(
            color: theme.textTheme.headlineMedium?.color,
            fontWeight: FontWeight.bold,
            fontFamily: 'Kodchasan',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.textTheme.titleMedium?.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Explore all design pages",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleMedium?.color,
                  fontFamily: 'Kodchasan',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Tap on any page to navigate and see the design implementation",
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.bodyMedium?.color,
                  fontFamily: 'Kodchasan',
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _buildPageCategory(
                      theme,
                      "Authentication & Onboarding",
                      [
                        _PageItem(
                          title: "Splash Screen",
                          description: "App loading screen with animations",
                          icon: Icons.smartphone,
                          route: AppRoutes.designSplash,
                        ),
                        _PageItem(
                          title: "Onboarding",
                          description: "Welcome screens for new users",
                          icon: Icons.swipe,
                          route: AppRoutes.onboarding,
                        ),
                        _PageItem(
                          title: "Login",
                          description: "User authentication screen",
                          icon: Icons.login,
                          route: AppRoutes.login,
                        ),
                        _PageItem(
                          title: "Register",
                          description: "User registration form",
                          icon: Icons.person_add,
                          route: AppRoutes.register,
                        ),
                        _PageItem(
                          title: "Email Verification",
                          description: "Email verification with OTP",
                          icon: Icons.email,
                          route: AppRoutes.emailVerification,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildPageCategory(
                      theme,
                      "Setup & Configuration",
                      [
                        _PageItem(
                          title: "Cuisine Selection",
                          description: "Choose preferred food types",
                          icon: Icons.restaurant_menu,
                          route: AppRoutes.cuisineSelection,
                        ),
                        _PageItem(
                          title: "Location Setup",
                          description: "Set delivery address",
                          icon: Icons.location_on,
                          route: AppRoutes.locationSetup,
                        ),
                        _PageItem(
                          title: "Setup Complete",
                          description: "Configuration completion screen",
                          icon: Icons.check_circle,
                          route: AppRoutes.setupComplete,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildPageCategory(
                      theme,
                      "Main App Features",
                      [
                        _PageItem(
                          title: "Search",
                          description: "Search for restaurants and food",
                          icon: Icons.search,
                          route: AppRoutes.search,
                        ),
                        _PageItem(
                          title: "Shopping Cart",
                          description: "Cart with order management",
                          icon: Icons.shopping_cart,
                          route: AppRoutes.cart,
                        ),
                        _PageItem(
                          title: "Profile",
                          description: "User profile and settings",
                          icon: Icons.person,
                          route: AppRoutes.profile,
                        ),
                        _PageItem(
                          title: "Payment Methods",
                          description: "Manage payment options",
                          icon: Icons.payment,
                          route: AppRoutes.paymentMethods,
                        ),
                        _PageItem(
                          title: "Order History",
                          description: "View past orders and tracking",
                          icon: Icons.history,
                          route: AppRoutes.orderHistory,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageCategory(
    ThemeData theme,
    String categoryTitle,
    List<_PageItem> pages,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryTitle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            fontFamily: 'Kodchasan',
          ),
        ),
        const SizedBox(height: 12),
        ...pages.map((page) => _buildPageTile(theme, page)),
      ],
    );
  }

  Widget _buildPageTile(ThemeData theme, _PageItem page) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(page.route),
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
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      page.icon,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          page.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.titleMedium?.color,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          page.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color,
                            fontFamily: 'Kodchasan',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;

  const _PageItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });
}
