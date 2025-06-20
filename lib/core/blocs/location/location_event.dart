import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

/// Evento para solicitar la ubicación actual
class RequestCurrentLocation extends LocationEvent {
  const RequestCurrentLocation();
}

/// Evento para verificar permisos de ubicación
class CheckLocationPermission extends LocationEvent {
  const CheckLocationPermission();
}

/// Evento para solicitar permisos de ubicación
class RequestLocationPermission extends LocationEvent {
  const RequestLocationPermission();
}

/// Evento para iniciar el seguimiento de ubicación
class StartLocationTracking extends LocationEvent {
  const StartLocationTracking();
}

/// Evento para detener el seguimiento de ubicación
class StopLocationTracking extends LocationEvent {
  const StopLocationTracking();
}

/// Evento para actualizar la configuración de ubicación
class UpdateLocationSettings extends LocationEvent {
  final bool enableHighAccuracy;
  final Duration timeLimit;
  final double distanceFilter;

  const UpdateLocationSettings({
    this.enableHighAccuracy = true,
    this.timeLimit = const Duration(seconds: 15),
    this.distanceFilter = 10.0,
  });

  @override
  List<Object> get props => [enableHighAccuracy, timeLimit, distanceFilter];
}
