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
import 'package:laferia/core/routes/app_router.dart';
import 'package:laferia/core/themes/design_theme.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TileCacheService.instance.initialize();

  serviceLocatorInit();

  await Supabase.initialize(
    url: 'https://afjxzqifefsurzounxxq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFmanh6cWlmZWZzdXJ6b3VueHhxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg5NDA5NTcsImV4cCI6MjA2NDUxNjk1N30.bJgDduYAg7Wb7_EfPtEDc-dCU4oJOPKB6Kr-sZCc54U',
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
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
        return MaterialApp.router(
          title: 'La Feria',
          debugShowCheckedModeBanner: false,
          theme: DesignTheme.lightTheme(context),
          darkTheme: DesignTheme.darkTheme(context),
          themeMode:
              themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          routerConfig: appRouter(),
        );
      },
    );
  }
}
