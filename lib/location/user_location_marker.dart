import 'package:flutter/material.dart';

class UserLocationMarker extends StatelessWidget {
  final double size;
  final Color color;
  final Color? backgroundColor;
  final double accuracy;
  final VoidCallback? onTap;

  const UserLocationMarker({
    super.key,
    this.size = 20.0,
    this.color = Colors.blue,
    this.backgroundColor,
    this.accuracy = 0.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo de precisión (opcional)
          if (accuracy > 0 && accuracy < 100)
            Container(
              width: size * 3,
              height: size * 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
                border: Border.all(color: color.withOpacity(0.3), width: 1),
              ),
            ),
          // Marcador principal
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor ?? Colors.white,
              border: Border.all(color: color, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
          // Icono de ubicación
          Icon(
            Icons.my_location,
            size: size * 0.6,
            color: backgroundColor ?? Colors.white,
          ),
        ],
      ),
    );
  }
}
