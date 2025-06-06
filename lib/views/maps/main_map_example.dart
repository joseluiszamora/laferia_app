import 'package:flutter/material.dart';
import 'package:laferia/views/maps/main_map.dart';

/// Ejemplo de cómo integrar el MainMap en tu aplicación
class MainMapExample extends StatelessWidget {
  const MainMapExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainMap();
  }

  /// Para usar en tu router/navegación:
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const MainMapExample());
  }
}

/// Si quieres usar el mapa dentro de otro widget como un contenedor
class MainMapContainer extends StatelessWidget {
  final double? height;
  final double? width;

  const MainMapContainer({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? MediaQuery.of(context).size.height * 0.7,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: const MainMap(),
    );
  }
}
