import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/blocs/categorias/categorias_bloc.dart';
import 'package:laferia/core/blocs/comentarios/comentarios_bloc.dart';
import 'package:laferia/core/blocs/location/location_bloc.dart';
import 'package:laferia/core/blocs/ofertas/ofertas_bloc.dart';
import 'package:laferia/core/blocs/productos/productos_bloc.dart';
import 'package:laferia/core/blocs/service_locator.dart';
import 'package:laferia/core/blocs/tiendas/tiendas_bloc.dart';
import 'package:laferia/core/providers/theme_provider.dart';
import 'package:laferia/core/providers/auth_provider.dart';
import 'package:laferia/core/themes/design_theme.dart';
import 'package:laferia/core/widgets/auth_wrapper.dart';
import 'package:laferia/views/auth/register_page.dart';
import 'package:laferia/views/auth/forgot_password_page.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/blocs/admin_productos/admin_productos.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TileCacheService.instance.initialize();

  serviceLocatorInit();

  await Supabase.initialize(
    url: 'https://sfporjwgzplyckosbdqx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNmcG9yandnenBseWNrb3NiZHF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTEzOTYyODQsImV4cCI6MjA2Njk3MjI4NH0.eqPIh0WgI4Tqqu_auoZ8rwkFTk7EiOTM042hxEjxe2Q',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    // Configurar para detectar deep links de OAuth
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const BlocsProviders(),
    ),
  );
}

class BlocsProviders extends StatelessWidget {
  const BlocsProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CategoriasBloc>(), lazy: true),
        BlocProvider(create: (context) => getIt<ComentariosBloc>(), lazy: true),
        BlocProvider(create: (context) => getIt<LocationBloc>(), lazy: true),
        BlocProvider(create: (context) => getIt<OfertasBloc>(), lazy: true),
        BlocProvider(create: (context) => getIt<ProductosBloc>(), lazy: true),
        BlocProvider(create: (context) => getIt<TiendasBloc>(), lazy: true),
        BlocProvider(
          create: (context) => getIt<AdminProductosBloc>(),
          lazy: true,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // return MaterialApp(
        //   title: 'La Feria',
        //   debugShowCheckedModeBanner: false,
        //   theme: DesignTheme.lightTheme(context),
        //   darkTheme: DesignTheme.darkTheme(context),
        //   themeMode:
        //       themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        //   home: AuthWrapper(),
        // );
        // Usar AuthWrapper en lugar del router para manejar autenticación
        return MaterialApp(
          title: 'La Feria',
          debugShowCheckedModeBanner: false,
          theme: DesignTheme.lightTheme(context),
          darkTheme: DesignTheme.darkTheme(context),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AuthWrapper(),
          // Mantener el router para navegación interna
          // onGenerateRoute: (settings) {
          //   // Manejar rutas específicas si es necesario
          //   switch (settings.name) {
          //     case '/new-register':
          //       return MaterialPageRoute(
          //         builder: (context) => const RegisterPage(),
          //       );
          //     case '/new-forgot-password':
          //       return MaterialPageRoute(
          //         builder: (context) => const ForgotPasswordPage(),
          //       );
          //     default:
          //       return null;
          //   }
          // },
        );
      },
    );
  }
}
