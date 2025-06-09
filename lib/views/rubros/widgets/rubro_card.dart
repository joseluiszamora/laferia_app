import 'package:flutter/material.dart';
import '../../../core/models/rubro.dart';

class RubroCard extends StatelessWidget {
  final Rubro rubro;
  final VoidCallback onTap;

  const RubroCard({super.key, required this.rubro, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icono del rubro
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  _getIconData(rubro.icono),
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              // Información del rubro
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rubro.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rubro.descripcion,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${rubro.totalCategorias} categorías',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${rubro.totalSubcategorias} subcategorías',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Flecha indicadora
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
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
