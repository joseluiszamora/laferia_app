import 'package:flutter/material.dart';
import '../views/categorias/categoria_detail_page.dart';
import '../core/models/categoria.dart';

/// Ejemplo de uso de CategoriaDetailPage
///
/// Este widget demuestra cómo integrar y usar la página de detalle de categoría
/// en diferentes contextos de la aplicación.
class CategoriaDetailExample extends StatelessWidget {
  const CategoriaDetailExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejemplo - Categoría Detail'),
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ejemplos de Categorías',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Lista de categorías de ejemplo
            Expanded(
              child: ListView(
                children: [
                  _buildCategoriaCard(
                    context,
                    _createEjemploComida(),
                    'Categoría con muchos productos',
                  ),
                  const SizedBox(height: 12),

                  _buildCategoriaCard(
                    context,
                    _createEjemploTecnologia(),
                    'Categoría con tiendas especializadas',
                  ),
                  const SizedBox(height: 12),

                  _buildCategoriaCard(
                    context,
                    _createEjemploRopa(),
                    'Categoría con imagen personalizada',
                  ),
                  const SizedBox(height: 12),

                  _buildCategoriaCard(
                    context,
                    _createEjemploVacia(),
                    'Categoría sin contenido (estado vacío)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriaCard(
    BuildContext context,
    Categoria categoria,
    String descripcion,
  ) {
    final color = _getColorFromString(categoria.color);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CategoriaDetailPage(categoria: categoria),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono de la categoría
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Icon(
                  _getIconFromString(categoria.icon),
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoria.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (categoria.description != null)
                      Text(
                        categoria.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    Text(
                      descripcion,
                      style: TextStyle(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Flecha
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Categorías de ejemplo
  Categoria _createEjemploComida() {
    return const Categoria(
      id: 1,
      name: 'Comida y Bebidas',
      slug: 'comida-bebidas',
      description:
          'Deliciosos productos alimenticios, bebidas refrescantes y especialidades culinarias de la región.',
      icon: 'restaurant',
      color: '#FF9800',
      imageUrl:
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400',
    );
  }

  Categoria _createEjemploTecnologia() {
    return const Categoria(
      id: 2,
      name: 'Tecnología',
      slug: 'tecnologia',
      description:
          'Dispositivos electrónicos de última generación, gadgets innovadores y accesorios tecnológicos.',
      icon: 'devices',
      color: '#2196F3',
    );
  }

  Categoria _createEjemploRopa() {
    return const Categoria(
      id: 3,
      name: 'Ropa y Accesorios',
      slug: 'ropa-accesorios',
      description:
          'Moda actual, vestimenta de calidad y accesorios únicos para todos los estilos.',
      icon: 'checkroom',
      color: '#9C27B0',
      imageUrl:
          'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?w=400',
    );
  }

  Categoria _createEjemploVacia() {
    return const Categoria(
      id: 999,
      name: 'Categoría Vacía',
      slug: 'categoria-vacia',
      description:
          'Esta categoría no tiene contenido para demostrar el estado vacío.',
      icon: 'category',
      color: '#9E9E9E',
    );
  }

  // Métodos helper (mismos que en CategoriaDetailPage)
  Color _getColorFromString(String? colorString) {
    if (colorString == null) return Colors.blue;
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getIconFromString(String? iconString) {
    if (iconString == null) return Icons.category;

    final iconMap = {
      'store': Icons.store,
      'restaurant': Icons.restaurant,
      'eco': Icons.eco,
      'checkroom': Icons.checkroom,
      'shopping_bag': Icons.shopping_bag,
      'directions_car': Icons.directions_car,
      'devices': Icons.devices,
      'menu_book': Icons.menu_book,
      'local_pharmacy': Icons.local_pharmacy,
      'build': Icons.build,
      'diamond': Icons.diamond,
      'local_florist': Icons.local_florist,
      'pets': Icons.pets,
      'face_retouching_natural': Icons.face_retouching_natural,
      'sports_soccer': Icons.sports_soccer,
      'home': Icons.home,
      'category': Icons.category,
    };

    return iconMap[iconString] ?? Icons.category;
  }
}
