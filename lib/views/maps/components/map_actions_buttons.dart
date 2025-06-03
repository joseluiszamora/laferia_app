import 'package:flutter/material.dart';

class MapActionButtons extends StatelessWidget {
  final VoidCallback onCenterLocation;
  final VoidCallback onRefresh;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final bool isDarkMode;

  const MapActionButtons({
    super.key,
    required this.onCenterLocation,
    required this.onRefresh,
    required this.onZoomIn,
    required this.onZoomOut,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = isDarkMode ? Colors.grey[850]! : Colors.grey[100]!;
    final iconColor = isDarkMode ? Colors.white : Colors.black87;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón de Zoom In
        _ModernFAB(
          heroTag: 'zoomIn',
          icon: Icons.add,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          onPressed: onZoomIn,
          tooltip: 'Acercar',
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Botón de Zoom Out
        _ModernFAB(
          heroTag: 'zoomOut',
          icon: Icons.remove,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          onPressed: onZoomOut,
          tooltip: 'Alejar',
          elevation: 4,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        const SizedBox(height: 8),
        // Botón de Centrar
        _ModernFAB(
          heroTag: 'centerLocation',
          icon: Icons.my_location,
          backgroundColor: primaryColor,
          iconColor: Colors.white,
          onPressed: onCenterLocation,
          tooltip: 'Mi ubicación',
          elevation: 6,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        const SizedBox(height: 8),
        // Botón de Actualizar
        _ModernFAB(
          heroTag: 'refreshMarkers',
          icon: Icons.refresh,
          backgroundColor: backgroundColor,
          iconColor: iconColor,
          onPressed: onRefresh,
          tooltip: 'Actualizar',
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModernFAB extends StatefulWidget {
  final String heroTag;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onPressed;
  final String tooltip;
  final double elevation;
  final ShapeBorder shape;

  const _ModernFAB({
    required this.heroTag,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
    required this.tooltip,
    required this.elevation,
    required this.shape,
  });

  @override
  State<_ModernFAB> createState() => _ModernFABState();
}

class _ModernFABState extends State<_ModernFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          elevation: widget.elevation,
          shape: widget.shape,
          color: widget.backgroundColor,
          child: InkWell(
            customBorder: widget.shape,
            onTap: widget.onPressed,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: Icon(widget.icon, color: widget.iconColor, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

// class _ModernFAB extends StatelessWidget {
//   final String heroTag;
//   final IconData icon;
//   final Color backgroundColor;
//   final Color iconColor;
//   final VoidCallback onPressed;
//   final String tooltip;
//   final double elevation;
//   final ShapeBorder shape;

//   const _ModernFAB({
//     required this.heroTag,
//     required this.icon,
//     required this.backgroundColor,
//     required this.iconColor,
//     required this.onPressed,
//     required this.tooltip,
//     required this.elevation,
//     required this.shape,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       heroTag: heroTag,
//       onPressed: onPressed,
//       tooltip: tooltip,
//       elevation: elevation,
//       highlightElevation: elevation + 2,
//       backgroundColor: backgroundColor,
//       shape: shape,
//       mini: true,
//       child: Icon(icon, color: iconColor, size: 20),
//     );
//   }
// }
