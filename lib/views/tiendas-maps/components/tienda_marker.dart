import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/core/models/models.dart';
import 'package:latlong2/latlong.dart';

class TiendaMarker {
  Marker makeTiendaMarker({
    required Tienda tienda,
    required double baseSize,
    required VoidCallback onTap,
  }) {
    Color color = Tienda.getColorFromHex(tienda.color);
    IconData icon = Tienda.getIconData(tienda.icon);

    // Determinar tamaño final con variación
    final double markerSize = baseSize * 1.2;

    return Marker(
      rotate: true,
      point: LatLng(tienda.ubicacion.lat, tienda.ubicacion.lng),
      width: markerSize,
      height: markerSize,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Globo del marker
            Container(
              // width: 40,
              // height: 40,
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
              child: Icon(icon, color: Colors.white, size: markerSize * 0.6),
            ),
            // Punta del marker
            Container(
              width: 0,
              height: 0,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.transparent, width: 5),
                  right: BorderSide(color: Colors.transparent, width: 5),
                  top: BorderSide(color: color, width: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
