import 'package:flutter/material.dart';
import 'package:laferia/maps/tile_cache_service.dart';
import 'package:laferia/maps/offline_map_config.dart';

class OfflineMapManager extends StatefulWidget {
  const OfflineMapManager({super.key});

  @override
  State<OfflineMapManager> createState() => _OfflineMapManagerState();
}

class _OfflineMapManagerState extends State<OfflineMapManager> {
  String selectedArea = 'centro_lapaz';
  String selectedZoomConfig = 'basico';
  String selectedProvider = 'openstreetmap';
  bool isDownloading = false;
  double downloadProgress = 0.0;
  int downloadedTiles = 0;
  int totalTiles = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestor de Mapas Offline'),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildConfigurationSection(),
            SizedBox(height: 20),
            _buildDownloadSection(),
            SizedBox(height: 20),
            _buildCacheStatsSection(),
            SizedBox(height: 20),
            _buildPresetAreasSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración de Descarga',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Selector de área
            DropdownButtonFormField<String>(
              value: selectedArea,
              decoration: InputDecoration(
                labelText: 'Área a descargar',
                border: OutlineInputBorder(),
              ),
              items:
                  OfflineMapConfig.predefinedAreas.keys.map((area) {
                    return DropdownMenuItem<String>(
                      value: area,
                      child: Text(_getAreaDisplayName(area)),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedArea = value!;
                });
              },
            ),

            SizedBox(height: 12),

            // Selector de nivel de detalle
            DropdownButtonFormField<String>(
              value: selectedZoomConfig,
              decoration: InputDecoration(
                labelText: 'Nivel de detalle',
                border: OutlineInputBorder(),
              ),
              items:
                  OfflineMapConfig.zoomConfigs.keys.map((config) {
                    return DropdownMenuItem<String>(
                      value: config,
                      child: Text(_getZoomConfigDisplayName(config)),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedZoomConfig = value!;
                });
              },
            ),

            SizedBox(height: 12),

            // Selector de proveedor de mapas
            DropdownButtonFormField<String>(
              value: selectedProvider,
              decoration: InputDecoration(
                labelText: 'Estilo de mapa',
                border: OutlineInputBorder(),
              ),
              items:
                  OfflineMapConfig.tileProviders.keys.map((provider) {
                    return DropdownMenuItem<String>(
                      value: provider,
                      child: Text(_getProviderDisplayName(provider)),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvider = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descarga de Tiles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            if (isDownloading) ...[
              LinearProgressIndicator(
                value: downloadProgress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
              SizedBox(height: 8),
              Text(
                'Descargando: $downloadedTiles / $totalTiles tiles',
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                '${(downloadProgress * 100).toStringAsFixed(1)}% completado',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _startDownload,
                      icon: Icon(Icons.download_for_offline),
                      label: Text('Descargar Área'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _estimateDownload,
                    icon: Icon(Icons.calculate),
                    label: Text('Estimar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCacheStatsSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas del Caché',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            FutureBuilder<Map<String, dynamic>>(
              future: TileCacheService.instance.getCacheStats(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final stats = snapshot.data!;
                  return Column(
                    children: [
                      _buildStatRow(
                        'Tiles almacenados:',
                        '${stats['tile_count'] ?? 0}',
                        Icons.map,
                      ),
                      _buildStatRow(
                        'Tamaño total:',
                        '${(stats['total_size_mb'] ?? 0).toStringAsFixed(2)} MB',
                        Icons.storage,
                      ),
                      if (stats['last_used'] != null)
                        _buildStatRow(
                          'Último uso:',
                          '${stats['last_used'].toString().split('.')[0]}',
                          Icons.access_time,
                        ),
                    ],
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),

            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _cleanOldCache,
                    icon: Icon(Icons.cleaning_services),
                    label: Text('Limpiar Caché'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => setState(() {}),
                  icon: Icon(Icons.refresh),
                  label: Text('Actualizar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetAreasSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Áreas Predefinidas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  OfflineMapConfig.predefinedAreas.keys.map((area) {
                    return ActionChip(
                      label: Text(_getAreaDisplayName(area)),
                      onPressed: () {
                        setState(() {
                          selectedArea = area;
                        });
                      },
                      backgroundColor:
                          selectedArea == area
                              ? Colors.blue.shade100
                              : Colors.grey.shade200,
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          SizedBox(width: 8),
          Expanded(
            child: Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getAreaDisplayName(String area) {
    switch (area) {
      case 'centro_lapaz':
        return 'Centro de La Paz';
      case 'zona_sur':
        return 'Zona Sur';
      case 'el_alto':
        return 'El Alto';
      case 'area_metropolitana':
        return 'Área Metropolitana';
      default:
        return area;
    }
  }

  String _getZoomConfigDisplayName(String config) {
    switch (config) {
      case 'basico':
        return 'Básico (rápido)';
      case 'detallado':
        return 'Detallado (recomendado)';
      case 'completo':
        return 'Completo (lento)';
      default:
        return config;
    }
  }

  String _getProviderDisplayName(String provider) {
    switch (provider) {
      case 'openstreetmap':
        return 'OpenStreetMap (clásico)';
      case 'cartodb_light':
        return 'CartoDB Claro';
      case 'cartodb_dark':
        return 'CartoDB Oscuro';
      case 'stadia_smooth':
        return 'Stadia Suave';
      case 'stadia_dark':
        return 'Stadia Oscuro';
      default:
        return provider;
    }
  }

  void _startDownload() async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0.0;
      downloadedTiles = 0;
      totalTiles = 0;
    });

    try {
      final area = OfflineMapConfig.predefinedAreas[selectedArea]!;
      final zoomLevels = OfflineMapConfig.zoomConfigs[selectedZoomConfig]!;
      final urlTemplate = OfflineMapConfig.tileProviders[selectedProvider]!;

      await TileCacheService.instance.preloadArea(
        northEast_lat: area['north']!,
        northEast_lng: area['east']!,
        southWest_lat: area['south']!,
        southWest_lng: area['west']!,
        zoomLevels: zoomLevels,
        urlTemplate: urlTemplate,
        onProgress: (current, total) {
          setState(() {
            downloadedTiles = current;
            totalTiles = total;
            downloadProgress = current / total;
          });
        },
      );

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  void _estimateDownload() {
    final zoomLevels = OfflineMapConfig.zoomConfigs[selectedZoomConfig]!;
    int estimatedTiles = 0;

    for (int zoom in zoomLevels) {
      // Estimación aproximada de tiles por nivel de zoom
      estimatedTiles += (4 << (zoom - 10)).clamp(4, 1000);
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Estimación de Descarga'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Área: ${_getAreaDisplayName(selectedArea)}'),
                Text(
                  'Detalle: ${_getZoomConfigDisplayName(selectedZoomConfig)}',
                ),
                Text('Estilo: ${_getProviderDisplayName(selectedProvider)}'),
                SizedBox(height: 16),
                Text(
                  'Tiles estimados: ~$estimatedTiles',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tamaño aproximado: ~${(estimatedTiles * 0.02).toStringAsFixed(1)} MB',
                ),
                Text(
                  'Tiempo estimado: ~${(estimatedTiles * 0.1).toStringAsFixed(0)} segundos',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startDownload();
                },
                child: Text('Descargar Ahora'),
              ),
            ],
          ),
    );
  }

  void _cleanOldCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Limpiar Caché'),
            content: Text(
              '¿Estás seguro de que quieres eliminar los tiles antiguos del caché?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Limpiar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await TileCacheService.instance.cleanOldCache();
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Caché limpiado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Descarga Completa'),
              ],
            ),
            content: Text(
              'Se han descargado $downloadedTiles tiles exitosamente. '
              'Ahora puedes usar el mapa offline en esta área.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Genial'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text('Error en Descarga'),
              ],
            ),
            content: Text('Ocurrió un error durante la descarga: $error'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar'),
              ),
            ],
          ),
    );
  }
}
