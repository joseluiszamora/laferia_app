import 'package:go_router/go_router.dart';
import 'package:laferia/views/navigation/navigation_bar_page.dart';
import 'package:laferia/views/splash/splash_page.dart';
import 'package:laferia/views/design/onboarding_page.dart';
import 'package:laferia/views/design/login_page.dart';
import 'package:laferia/views/design/register_page.dart';
import 'package:laferia/views/design/email_verification_page.dart';
import 'package:laferia/views/design/cuisine_selection_page.dart';
import 'package:laferia/views/design/location_setup_page.dart';
import 'package:laferia/views/design/setup_complete_page.dart';
import 'package:laferia/views/design/design_pages.dart';
import 'package:laferia/views/design/search_page.dart';
import 'package:laferia/views/design/cart_page.dart';
import 'package:laferia/views/design/profile_page.dart';
import 'package:laferia/views/design/payment_methods_page.dart';
import 'package:laferia/views/design/order_history_page.dart';

import 'app_routes.dart';

GoRouter appRouter() => GoRouter(
  // Cambiar initialLocation a la página de diseño
  initialLocation: AppRoutes.splash,
  routes: publicRoutes(),
  redirect: (context, state) {
    final isSplashRoute = state.matchedLocation == AppRoutes.splash;
    // final isDesignPageRoute = state.matchedLocation == AppRoutes.designPages;

    // Si está en splash, permitir
    if (isSplashRoute) return null;

    // // Si está en design pages, permitir
    // if (isDesignPageRoute) return null;

    // return null;
  },
);

List<RouteBase> publicRoutes() => [
  /* <---- AUTH -----> */
  GoRoute(
    path: AppRoutes.splash,
    builder: (context, state) => const SplashPage(),
  ),

  /* <---- DESIGN FLOW -----> */
  GoRoute(
    path: AppRoutes.designPages,
    name: 'DesignPages',
    builder: (context, state) => const DesignPagesPage(),
  ),
  GoRoute(
    path: AppRoutes.onboarding,
    name: 'Onboarding',
    builder: (context, state) => const OnboardingPage(),
  ),
  GoRoute(
    path: AppRoutes.login,
    name: 'Login',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.register,
    name: 'Register',
    builder: (context, state) => const RegisterPage(),
  ),
  GoRoute(
    path: AppRoutes.emailVerification,
    name: 'EmailVerification',
    builder:
        (context, state) => EmailVerificationPage(
          email: state.extra as String? ?? 'user@example.com',
        ),
  ),
  GoRoute(
    path: AppRoutes.cuisineSelection,
    name: 'CuisineSelection',
    builder: (context, state) => const CuisineSelectionPage(),
  ),
  GoRoute(
    path: AppRoutes.locationSetup,
    name: 'LocationSetup',
    builder: (context, state) => const LocationSetupPage(),
  ),
  GoRoute(
    path: AppRoutes.setupComplete,
    name: 'SetupComplete',
    builder: (context, state) => const SetupCompletePage(),
  ),
  GoRoute(
    path: AppRoutes.search,
    name: 'Search',
    builder: (context, state) => const SearchPage(),
  ),
  GoRoute(
    path: AppRoutes.cart,
    name: 'Cart',
    builder: (context, state) => const CartPage(),
  ),
  GoRoute(
    path: AppRoutes.profile,
    name: 'Profile',
    builder: (context, state) => const ProfilePage(),
  ),
  GoRoute(
    path: AppRoutes.paymentMethods,
    name: 'PaymentMethods',
    builder: (context, state) => const PaymentMethodsPage(),
  ),
  GoRoute(
    path: AppRoutes.orderHistory,
    name: 'OrderHistory',
    builder: (context, state) => const OrderHistoryPage(),
  ),

  // GoRoute(
  //   path: AppRoutes.authLogin,
  //   name: 'Login',
  //   builder: (context, state) => const LoginPage(),
  // ),
  GoRoute(
    path: AppRoutes.navigation,
    name: 'Inicio',
    builder: (context, state) => const NavigationBarPage(),
  ),
];
