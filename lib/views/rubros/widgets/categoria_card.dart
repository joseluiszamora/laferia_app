import 'package:flutter/material.dart';
import '../../../core/models/categoria.dart';

class CategoriaCard extends StatelessWidget {
  final Categoria categoria;
  final VoidCallback onTap;

  const CategoriaCard({
    super.key,
    required this.categoria,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono de la categoría
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(categoria.icono),
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              // Información de la categoría
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoria.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categoria.descripcion,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${categoria.totalSubcategorias} subcategorías',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Flecha indicadora
              Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'car_repair':
        return Icons.car_repair;
      case 'directions_car':
        return Icons.directions_car;
      case 'checkroom':
        return Icons.checkroom;
      case 'devices':
        return Icons.devices;
      case 'chair':
        return Icons.chair;
      case 'battery_alert':
        return Icons.battery_alert;
      case 'disc_full':
        return Icons.disc_full;
      case 'tire_repair':
        return Icons.tire_repair;
      case 'motorcycle':
        return Icons.motorcycle;
      case 'new_releases':
        return Icons.new_releases;
      case 'recycling':
        return Icons.recycling;
      case 'smartphone':
        return Icons.smartphone;
      case 'computer':
        return Icons.computer;
      case 'weekend':
        return Icons.weekend;
      case 'kitchen':
        return Icons.kitchen;
      default:
        return Icons.category;
    }
  }
}
