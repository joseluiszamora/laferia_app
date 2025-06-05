import 'package:flutter/material.dart';
import 'package:laferia/maps/offline_map_config.dart';

/// Ejemplo simple de cómo cambiar el proveedor de mapas mediante código
class QuickProviderChangeExample {
  /// Cambiar a OpenStreetMap estándar
  static void setToOpenStreetMap() {
    // En un caso real, esto requeriría modificar el archivo de configuración
    // o usar un sistema de preferencias/estado
    print('Para cambiar a OpenStreetMap, modifica:');
    print('OfflineMapConfig.defaultProvider = "openstreetmap"');
  }

  /// Cambiar a CartoDB Light (recomendado para uso diurno)
  static void setToCartoDarkLight() {
    print('Para cambiar a CartoDB Light, modifica:');
    print('OfflineMapConfig.defaultProvider = "cartodb_light"');
  }

  /// Cambiar a CartoDB Dark (recomendado para uso nocturno)
  static void setToCartoDark() {
    print('Para cambiar a CartoDB Dark, modifica:');
    print('OfflineMapConfig.defaultProvider = "cartodb_dark"');
  }

  /// Cambiar a Stadia Smooth (estilo moderno)
  static void setToStadiaSmooth() {
    print('Para cambiar a Stadia Smooth, modifica:');
    print('OfflineMapConfig.defaultProvider = "stadia_smooth"');
  }

  /// Cambiar a Stadia Dark (estilo moderno oscuro)
  static void setToStadiaDark() {
    print('Para cambiar a Stadia Dark, modifica:');
    print('OfflineMapConfig.defaultProvider = "stadia_dark"');
  }

  /// Widget para demostrar cómo crear un selector de proveedor simple
  static Widget buildSimpleProviderSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cambiar Estilo de Mapa',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          const Text(
            'Para cambiar el estilo por defecto, modifica el archivo:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Text(
              'lib/maps/offline_map_config.dart\n\n'
              'Cambia la línea:\n'
              'static const String defaultProvider = "cartodb_dark";',
              style: TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),

          const SizedBox(height: 16),
          const Text('Opciones disponibles:'),
          const SizedBox(height: 8),

          _buildProviderOption(
            'openstreetmap',
            'OpenStreetMap',
            'Mapa estándar',
          ),
          _buildProviderOption(
            'cartodb_light',
            'CartoDB Light',
            'Estilo claro',
          ),
          _buildProviderOption('cartodb_dark', 'CartoDB Dark', 'Estilo oscuro'),
          _buildProviderOption(
            'stadia_smooth',
            'Stadia Smooth',
            'Moderno suave',
          ),
          _buildProviderOption('stadia_dark', 'Stadia Dark', 'Moderno oscuro'),
        ],
      ),
    );
  }

  static Widget _buildProviderOption(
    String id,
    String name,
    String description,
  ) {
    final isSelected = OfflineMapConfig.defaultProvider == id;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected ? Colors.blue : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.blue[700] : Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (isSelected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'ACTUAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Widget de demostración para mostrar información del proveedor actual
class CurrentProviderInfo extends StatelessWidget {
  const CurrentProviderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Configuración Actual',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              'Proveedor por defecto:',
              OfflineMapConfig.defaultProvider,
            ),
            _buildInfoRow('URL:', OfflineMapConfig.getDefaultTileUrl()),
            _buildInfoRow(
              'Subdominios:',
              OfflineMapConfig.getDefaultSubdomains().join(', '),
            ),
            _buildInfoRow(
              'Atribución:',
              OfflineMapConfig.getDefaultAttribution(),
            ),

            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: const [
                  Icon(Icons.lightbulb_outline, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reinicia la app después de cambiar el proveedor por defecto para ver los cambios.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}
