import 'package:flutter/material.dart';

class TiendaMarker extends StatelessWidget {
  const TiendaMarker({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Globo del marker
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
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
    );
  }
}
