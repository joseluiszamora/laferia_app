import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laferia/core/providers/theme_provider.dart';
import 'package:laferia/core/routes/app_router.dart';
import 'package:laferia/core/themes/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return const MyApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'DLZA Legal App',
          debugShowCheckedModeBanner: false,
          theme:
              themeProvider.isDarkMode
                  ? AppTheme.darkTheme(context)
                  : AppTheme.lightTheme(context),
          routerConfig: appRouter(),
        );
      },
    );
  }
}
