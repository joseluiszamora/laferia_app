import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/blocs/location/location.dart';

class LocationButton extends StatelessWidget {
  final VoidCallback? onLocationFound;
  final Color? color;
  final Color? backgroundColor;

  const LocationButton({
    super.key,
    this.onLocationFound,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, state) {
        return Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _handleLocationRequest(context, state),
              child: Center(child: _buildIcon(state)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(LocationState state) {
    final iconColor = color ?? Colors.blue;

    if (state is LocationLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
        ),
      );
    }

    if (state is LocationLoaded || state is LocationTracking) {
      return Icon(Icons.my_location, color: iconColor, size: 24);
    }

    if (state is LocationError ||
        state is LocationPermissionDenied ||
        state is LocationServiceDisabled) {
      return Icon(Icons.location_disabled, color: Colors.red, size: 24);
    }

    return Icon(Icons.location_searching, color: iconColor, size: 24);
  }

  void _handleLocationRequest(BuildContext context, LocationState state) {
    final locationBloc = context.read<LocationBloc>();

    if (state is LocationLoading) {
      return; // Ya está cargando
    }

    if (state is LocationPermissionDenied) {
      if (state.permanentlyDenied) {
        _showPermissionDialog(context);
      } else {
        locationBloc.add(const RequestLocationPermission());
      }
      return;
    }

    if (state is LocationServiceDisabled) {
      _showServiceDisabledDialog(context);
      return;
    }

    if (state is LocationError) {
      locationBloc.add(const RequestCurrentLocation());
      return;
    }

    if (state is LocationLoaded) {
      onLocationFound?.call();
      return;
    }

    // Estado inicial o cualquier otro estado
    locationBloc.add(const RequestCurrentLocation());
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Permisos de ubicación'),
            content: const Text(
              'Los permisos de ubicación están permanentemente denegados. '
              'Ve a la configuración de la aplicación para habilitarlos.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Aquí podrías abrir la configuración de la app
                  // usando package:app_settings si está disponible
                },
                child: const Text('Configuración'),
              ),
            ],
          ),
    );
  }

  void _showServiceDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Servicio de ubicación'),
            content: const Text(
              'El servicio de ubicación está deshabilitado. '
              'Actívalo en la configuración de tu dispositivo.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
