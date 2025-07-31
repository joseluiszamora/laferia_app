import 'package:flutter/material.dart';
import 'package:laferia/core/models/tienda.dart';

class MapboxTiendaMarker {
  /// Crea un widget de marcador personalizado para Mapbox
  static Widget createMarkerWidget({
    required Tienda tienda,
    double baseSize = 40.0,
    VoidCallback? onTap,
  }) {
    final Color color = Tienda.getColorFromHex(tienda.color);
    final IconData icon = Tienda.getIconData(tienda.icon);
    final double markerSize = baseSize * 1.2;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: markerSize,
        height: markerSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Globo del marker principal
            Container(
              width: markerSize * 0.75,
              height: markerSize * 0.75,
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: markerSize * 0.45),
            ),
            // Punta del marker (triángulo)
            Container(
              width: 0,
              height: 0,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.transparent, width: 6),
                  right: BorderSide(color: Colors.transparent, width: 6),
                  top: BorderSide(color: color, width: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Crea un marcador simple sin punta para usar como overlay
  static Widget createSimpleMarkerWidget({
    required Tienda tienda,
    double size = 30.0,
    VoidCallback? onTap,
  }) {
    final Color color = Tienda.getColorFromHex(tienda.color);
    final IconData icon = Tienda.getIconData(tienda.icon);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.6),
      ),
    );
  }

  /// Obtiene el color principal del marcador para una tienda
  static Color getMarkerColor(Tienda tienda) {
    return Tienda.getColorFromHex(tienda.color);
  }

  /// Obtiene el icono para una tienda
  static IconData getMarkerIcon(Tienda tienda) {
    return Tienda.getIconData(tienda.icon);
  }

  /// Crea información flotante para mostrar sobre el marcador
  static Widget createInfoBubble({
    required Tienda tienda,
    VoidCallback? onTap,
  }) {
    final Color color = Tienda.getColorFromHex(tienda.color);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Tienda.getIconData(tienda.icon), color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              tienda.name,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
