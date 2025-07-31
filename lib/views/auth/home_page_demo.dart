import 'package:flutter/material.dart';
import 'package:laferia/views/auth/login_page.dart';
import '../../core/services/auth_service_new.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageDemo extends StatelessWidget {
  const HomePageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LaFeria - Demo'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del usuario
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido!',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (user != null) ...[
                      Text('Email: ${user.email ?? 'No disponible'}'),
                      const SizedBox(height: 4),
                      Text('ID: ${user.id}'),
                      const SizedBox(height: 4),
                      Text('Registrado: ${user.createdAt}'),
                      if (user.userMetadata?['full_name'] != null) ...[
                        const SizedBox(height: 4),
                        Text('Nombre: ${user.userMetadata?['full_name']}'),
                      ],
                    ] else
                      const Text('Usuario no autenticado'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Funcionalidades de demo
            Text(
              'Funcionalidades Disponibles',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Botones de demo
            _DemoButton(
              icon: Icons.map,
              title: 'Ver Mapa',
              subtitle: 'Explora tiendas en el mapa',
              onTap: () {
                // Navigator.of(context).pushNamed('/navigation');
              },
            ),

            const SizedBox(height: 12),

            _DemoButton(
              icon: Icons.store,
              title: 'Lista de Tiendas',
              subtitle: 'Ver todas las tiendas disponibles',
              onTap: () {
                // Navigator.of(context).pushNamed('/tiendas_list');
              },
            ),

            const SizedBox(height: 12),

            _DemoButton(
              icon: Icons.person,
              title: 'Perfil',
              subtitle: 'Gestiona tu perfil de usuario',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Funcionalidad en desarrollo'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
            ),

            const Spacer(),

            // Información del sistema de autenticación
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Sistema de Autenticación',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '✅ Login con Email/Contraseña\n'
                    '✅ Registro de usuarios\n'
                    '✅ Recuperación de contraseña\n'
                    '🔄 Google OAuth (en desarrollo)\n'
                    '✅ Gestión de sesiones con Supabase',
                    style: TextStyle(color: Colors.blue[700], fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final result = await AuthService.signOut();

      if (result.isSuccess) {
        if (context.mounted) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cerrar sesión: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

class _DemoButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DemoButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green[100],
          child: Icon(icon, color: Colors.green[700]),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
