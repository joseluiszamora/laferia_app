import 'package:flutter/material.dart';

class ZoomCenterControls extends StatelessWidget {
  const ZoomCenterControls({
    super.key,
    required this.zoomIn,
    required this.zoomOut,
    required this.onCenter,
  });

  final Function() zoomIn;
  final Function() zoomOut;
  final Function() onCenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blueGrey),
                tooltip: 'Acercar',
                onPressed: zoomIn,
              ),
              Container(
                height: 1,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.blueGrey),
                tooltip: 'Alejar',
                onPressed: zoomOut,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.my_location, color: Colors.blueGrey),
            tooltip: 'Centrar',
            onPressed: onCenter,
          ),
        ),
      ],
    );
  }
}
