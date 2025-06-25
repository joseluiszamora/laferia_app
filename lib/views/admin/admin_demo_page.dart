import 'package:flutter/material.dart';
import 'package:laferia/views/admin/admin_categorias_pages.dart';
import 'package:laferia/views/admin_components/admin_card.dart';
import 'tiendas/tiendas.dart';

class AdminDemoPage extends StatelessWidget {
  const AdminDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Módulos de Administración',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Card para Categorías
            AdminCard(
              title: 'Gestión de Categorías',
              description: 'Administrar categorías y subcategorías del sistema',
              icon: Icons.category,
              color: Colors.blue,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminCategoriasPages(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Card para Productos (placeholder)
            AdminCard(
              title: 'Gestión de Productos',
              description: 'Administrar productos del marketplace',
              icon: Icons.shopping_bag,
              color: Colors.green,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Módulo en desarrollo')),
                );
              },
            ),

            const SizedBox(height: 16),

            // Card para Tiendas
            AdminCard(
              title: 'Gestión de Tiendas',
              description: 'Administrar tiendas registradas',
              icon: Icons.store,
              color: Colors.orange,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AdminTiendasPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
