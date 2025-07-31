import 'package:flutter/material.dart';
import 'package:laferia/views/navigation/navigation_bar_page.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../views/auth/login_page.dart';
import '../../views/auth/home_page_demo.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Mostrar splash/loading mientras se inicializa
        if (!authProvider.isInitialized || authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'LaFeria',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Cargando...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Si está autenticado, mostrar la app principal
        if (authProvider.isAuthenticated) {
          return const NavigationBarPage();
        }

        // Si no está autenticado, mostrar login
        return const LoginPage();
      },
    );
  }
}
