import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:laferia/core/routes/app_routes.dart';
import 'package:laferia/core/constants/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() {
    // Navegar automáticamente después de verificar la autenticación
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(AppRoutes.navigation);
      }
    });
  }

  @override
  void dispose() {
    // Cancelar el timer cuando el widget se desmonte
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o imagen de la app
            Image.asset(
              'assets/images/logo.png',
              height: 150,
              // Si la imagen no existe, usa un fallback
              errorBuilder:
                  (context, error, stackTrace) => const Icon(
                    Icons.store,
                    size: 120,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 30),
            Text(
              'La Feria',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
