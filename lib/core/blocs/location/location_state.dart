import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class LocationInitial extends LocationState {
  const LocationInitial();
}

/// Estado de carga
class LocationLoading extends LocationState {
  const LocationLoading();
}

/// Estado con ubicación obtenida exitosamente
class LocationLoaded extends LocationState {
  final Position position;
  final DateTime timestamp;

  const LocationLoaded({required this.position, required this.timestamp});

  @override
  List<Object> get props => [position, timestamp];

  /// Obtiene la latitud
  double get latitude => position.latitude;

  /// Obtiene la longitud
  double get longitude => position.longitude;

  /// Obtiene la precisión en metros
  double get accuracy => position.accuracy;

  /// Verifica si la ubicación es reciente (menos de 5 minutos)
  bool get isRecent {
    final now = DateTime.now();
    return now.difference(timestamp).inMinutes < 5;
  }
}

/// Estado de error
class LocationError extends LocationState {
  final String message;
  final LocationErrorType errorType;

  const LocationError({required this.message, required this.errorType});

  @override
  List<Object> get props => [message, errorType];
}

/// Estado cuando los permisos están denegados
class LocationPermissionDenied extends LocationState {
  final String message;
  final bool permanentlyDenied;

  const LocationPermissionDenied({
    required this.message,
    this.permanentlyDenied = false,
  });

  @override
  List<Object> get props => [message, permanentlyDenied];
}

/// Estado cuando el servicio de ubicación está deshabilitado
class LocationServiceDisabled extends LocationState {
  final String message;

  const LocationServiceDisabled({required this.message});

  @override
  List<Object> get props => [message];
}

/// Estado de seguimiento activo de ubicación
class LocationTracking extends LocationState {
  final Position currentPosition;
  final List<Position> locationHistory;
  final DateTime lastUpdate;

  const LocationTracking({
    required this.currentPosition,
    required this.locationHistory,
    required this.lastUpdate,
  });

  @override
  List<Object> get props => [currentPosition, locationHistory, lastUpdate];

  /// Copia el estado con nuevos valores
  LocationTracking copyWith({
    Position? currentPosition,
    List<Position>? locationHistory,
    DateTime? lastUpdate,
  }) {
    return LocationTracking(
      currentPosition: currentPosition ?? this.currentPosition,
      locationHistory: locationHistory ?? this.locationHistory,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

/// Tipos de errores de ubicación
enum LocationErrorType {
  permissionDenied,
  serviceDisabled,
  timeout,
  positionUnavailable,
  unknown,
}
