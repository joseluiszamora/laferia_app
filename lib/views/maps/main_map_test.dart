import 'package:flutter/material.dart';
import 'package:laferia/views/maps/main_map.dart';

class MainMapTest extends StatelessWidget {
  const MainMapTest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test MainMap',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test del Selector de Mapas'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const MainMap(),
      ),
    );
  }
}

void main() {
  runApp(const MainMapTest());
}
