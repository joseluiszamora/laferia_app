import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:laferia/views/maps/components/map_actions_buttons.dart';
import 'package:latlong2/latlong.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late MapController _mapController;
  double _currentZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMoveEnd) {
        setState(() {
          _currentZoom = event.camera.zoom;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(-16.5000, -68.1500), // La Paz, Bolivia
          initialZoom: _currentZoom,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.laferia_app',
          ),
        ],
      ),
      floatingActionButton: MapActionButtons(
        onCenterLocation: () {
          // _mapController.move(widget.pointCenter, _mapController.camera.zoom);
        },
        onRefresh: () => {},
        onZoomIn: () {
          _mapController.move(
            _mapController.camera.center,
            _mapController.camera.zoom + 1,
          );
        },
        onZoomOut: () {
          _mapController.move(
            _mapController.camera.center,
            _mapController.camera.zoom - 1,
          );
        },
        isDarkMode: false,
      ),
    );
  }
}
