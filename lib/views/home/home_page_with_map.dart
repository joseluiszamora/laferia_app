import 'package:flutter/material.dart';
import 'package:laferia/maps/examples/quick_provider_change_example.dart';
import 'package:laferia/maps/map_navigation_helper.dart';

class HomePageWithMap extends StatelessWidget {
  const HomePageWithMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('La Feria App'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => MapNavigationHelper.openMap(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Otros widgets de la app...

            // Card del mapa offline
            MapNavigationHelper.buildMapCard(context),

            // Más contenido...
            CurrentProviderInfo(),
          ],
        ),
      ),
    );
  }
}
