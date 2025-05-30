import 'package:go_router/go_router.dart';
import 'package:laferia/views/navigation/navigation_bar_page.dart';
import 'package:laferia/views/splash/splash_page.dart';

import 'app_routes.dart';

GoRouter appRouter() => GoRouter(
  // Cambiar initialLocation al splash
  initialLocation: AppRoutes.splash,
  routes: publicRoutes(),
  redirect: (context, state) {
    final isSplashRoute = state.matchedLocation == AppRoutes.splash;

    // Si está en splash, permitir
    if (isSplashRoute) return null;

    return null;
  },
);

List<RouteBase> publicRoutes() => [
  /* <---- AUTH -----> */
  GoRoute(
    path: AppRoutes.splash,
    builder: (context, state) => const SplashPage(),
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
