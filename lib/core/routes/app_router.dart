import 'package:go_router/go_router.dart';
import 'package:laferia/views/home/home_page_with_map.dart';
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
import 'package:laferia/views/tienda/tienda_list_page.dart';

// Importar nuestra nueva página de recuperación de contraseña
import 'package:laferia/views/auth/forgot_password_page.dart';
// Importar nuestras páginas de autenticación mejoradas
import 'package:laferia/views/auth/login_page.dart' as new_auth;
import 'package:laferia/views/auth/register_page.dart' as new_auth;
import 'package:laferia/views/auth/home_page_demo.dart';

import 'app_routes.dart';

GoRouter appRouter() => GoRouter(
  // Cambiar initialLocation a nuestra nueva página de login
  initialLocation: AppRoutes.newLogin,
  routes: publicRoutes(),
  redirect: (context, state) {
    final isSplashRoute = state.matchedLocation == AppRoutes.splash;
    // final isDesignPageRoute = state.matchedLocation == AppRoutes.designPages;

    // Si está en splash, permitir
    if (isSplashRoute) return null;

    // // Si está en design pages, permitir
    // if (isDesignPageRoute) return null;

    return null;
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
    path: AppRoutes.forgotPassword,
    name: 'ForgotPassword',
    builder: (context, state) => const ForgotPasswordPage(),
  ),

  /* <---- NUEVAS PÁGINAS DE AUTENTICACIÓN -----> */
  GoRoute(
    path: AppRoutes.newLogin,
    name: 'NewLogin',
    builder: (context, state) => const new_auth.LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.newRegister,
    name: 'NewRegister',
    builder: (context, state) => const new_auth.RegisterPage(),
  ),
  GoRoute(
    path: AppRoutes.newForgotPassword,
    name: 'NewForgotPassword',
    builder: (context, state) => const ForgotPasswordPage(),
  ),
  GoRoute(
    path: AppRoutes.homeDemo,
    name: 'HomeDemo',
    builder: (context, state) => const HomePageDemo(),
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

  // Paginas de diseño
  GoRoute(
    path: AppRoutes.homePageWithMap,
    name: 'Inicio Map',
    builder: (context, state) => const HomePageWithMap(),
  ),
  GoRoute(
    path: AppRoutes.tiendasList,
    name: 'Tiendas',
    builder: (context, state) => const TiendaListPage(),
  ),
];
