import 'package:flutter/material.dart';
import 'package:laferia/core/models/tienda.dart';
import 'package:laferia/views/tienda/tienda_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';

class TiendaInfo extends StatelessWidget {
  const TiendaInfo({super.key, required this.tienda});

  final Tienda tienda;

  @override
  Widget build(BuildContext context) {
    Color color = Tienda.getColorFromHex(tienda.color);
    IconData icon = Tienda.getIconData(tienda.icon);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Título con color
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  tienda.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Descripción
          Text(
            '${tienda.direccion} - ${tienda.horarioAtencion}',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    _openInGoogleMaps(tienda);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Cómo llegar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _navigateToTiendaDetail(context, tienda),
                  icon: const Icon(Icons.info),
                  label: const Text('Más info'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openInGoogleMaps(Tienda tienda) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${tienda.ubicacion.lat},${tienda.ubicacion.lng}&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _navigateToTiendaDetail(BuildContext context, Tienda tienda) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => TiendaDetailPage(tienda: tienda)),
    );
  }
}
