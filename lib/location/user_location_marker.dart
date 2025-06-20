import 'package:flutter/material.dart';

class UserLocationMarker extends StatefulWidget {
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
  State<UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<UserLocationMarker>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Círculo de precisión (opcional)
              if (widget.accuracy > 0 && widget.accuracy < 100)
                Container(
                  width: widget.size * 3,
                  height: widget.size * 3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.1),
                    border: Border.all(
                      color: widget.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              // Efecto de pulsación
              Transform.scale(
                scale: 1.0 + (_pulseAnimation.value * 0.3),
                child: Container(
                  width: widget.size * 2,
                  height: widget.size * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(
                      0.2 * (1.0 - _pulseAnimation.value),
                    ),
                  ),
                ),
              ),
              // Marcador principal
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.backgroundColor ?? Colors.white,
                  border: Border.all(color: widget.color, width: 3),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
              // Icono de ubicación
              Icon(
                Icons.my_location,
                size: widget.size * 0.6,
                color: widget.backgroundColor ?? Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
