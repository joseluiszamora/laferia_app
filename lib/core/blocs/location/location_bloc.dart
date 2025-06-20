import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionStreamSubscription;
  final List<Position> _locationHistory = [];

  LocationBloc() : super(const LocationInitial()) {
    on<CheckLocationPermission>(_onCheckLocationPermission);
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<RequestCurrentLocation>(_onRequestCurrentLocation);
    on<StartLocationTracking>(_onStartLocationTracking);
    on<StopLocationTracking>(_onStopLocationTracking);
    on<UpdateLocationSettings>(_onUpdateLocationSettings);
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    return super.close();
  }

  /// Verifica los permisos de ubicación
  Future<void> _onCheckLocationPermission(
    CheckLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    try {
      // Verificar si el servicio está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          const LocationServiceDisabled(
            message: 'El servicio de ubicación está deshabilitado',
          ),
        );
        return;
      }

      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.denied:
          emit(
            const LocationPermissionDenied(
              message: 'Los permisos de ubicación están denegados',
            ),
          );
          break;
        case LocationPermission.deniedForever:
          emit(
            const LocationPermissionDenied(
              message:
                  'Los permisos de ubicación están permanentemente denegados',
              permanentlyDenied: true,
            ),
          );
          break;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          // Permisos concedidos, se puede proceder
          break;
        case LocationPermission.unableToDetermine:
          emit(
            const LocationError(
              message: 'No se pudo determinar el estado de los permisos',
              errorType: LocationErrorType.unknown,
            ),
          );
          break;
      }
    } catch (e) {
      emit(
        LocationError(
          message: 'Error al verificar permisos: $e',
          errorType: LocationErrorType.unknown,
        ),
      );
    }
  }

  /// Solicita permisos de ubicación
  Future<void> _onRequestLocationPermission(
    RequestLocationPermission event,
    Emitter<LocationState> emit,
  ) async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      switch (permission) {
        case LocationPermission.denied:
          emit(
            const LocationPermissionDenied(
              message: 'Los permisos de ubicación fueron denegados',
            ),
          );
          break;
        case LocationPermission.deniedForever:
          emit(
            const LocationPermissionDenied(
              message:
                  'Los permisos de ubicación están permanentemente denegados. Ve a configuración para habilitarlos',
              permanentlyDenied: true,
            ),
          );
          break;
        case LocationPermission.whileInUse:
        case LocationPermission.always:
          // Permisos concedidos, intentar obtener ubicación
          add(const RequestCurrentLocation());
          break;
        case LocationPermission.unableToDetermine:
          emit(
            const LocationError(
              message: 'No se pudo determinar el estado de los permisos',
              errorType: LocationErrorType.unknown,
            ),
          );
          break;
      }
    } catch (e) {
      emit(
        LocationError(
          message: 'Error al solicitar permisos: $e',
          errorType: LocationErrorType.unknown,
        ),
      );
    }
  }

  /// Obtiene la ubicación actual
  Future<void> _onRequestCurrentLocation(
    RequestCurrentLocation event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());

    try {
      // Verificar permisos y servicio primero
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          const LocationServiceDisabled(
            message: 'El servicio de ubicación está deshabilitado',
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(
            const LocationPermissionDenied(
              message: 'Los permisos de ubicación están denegados',
            ),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          const LocationPermissionDenied(
            message:
                'Los permisos de ubicación están permanentemente denegados',
            permanentlyDenied: true,
          ),
        );
        return;
      }

      // Obtener ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      emit(LocationLoaded(position: position, timestamp: DateTime.now()));
    } on LocationServiceDisabledException {
      emit(
        const LocationServiceDisabled(
          message: 'El servicio de ubicación está deshabilitado',
        ),
      );
    } on PermissionDeniedException {
      emit(
        const LocationPermissionDenied(
          message: 'Los permisos de ubicación están denegados',
        ),
      );
    } on TimeoutException {
      emit(
        const LocationError(
          message: 'Tiempo de espera agotado al obtener la ubicación',
          errorType: LocationErrorType.timeout,
        ),
      );
    } catch (e) {
      emit(
        LocationError(
          message: 'Error al obtener la ubicación: $e',
          errorType: LocationErrorType.unknown,
        ),
      );
    }
  }

  /// Inicia el seguimiento de ubicación en tiempo real
  Future<void> _onStartLocationTracking(
    StartLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    try {
      // Verificar permisos primero
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(
          const LocationServiceDisabled(
            message: 'El servicio de ubicación está deshabilitado',
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        final isForever = permission == LocationPermission.deniedForever;
        emit(
          LocationPermissionDenied(
            message: 'Los permisos de ubicación están denegados',
            permanentlyDenied: isForever,
          ),
        );
        return;
      }

      // Cancelar suscripción anterior si existe
      await _positionStreamSubscription?.cancel();

      // Configurar el stream de posiciones
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Actualizar cada 10 metros
      );

      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _locationHistory.add(position);
          // Mantener solo las últimas 50 posiciones
          if (_locationHistory.length > 50) {
            _locationHistory.removeAt(0);
          }

          if (!isClosed) {
            emit(
              LocationTracking(
                currentPosition: position,
                locationHistory: List.from(_locationHistory),
                lastUpdate: DateTime.now(),
              ),
            );
          }
        },
        onError: (error) {
          if (!isClosed) {
            emit(
              LocationError(
                message: 'Error en el seguimiento de ubicación: $error',
                errorType: LocationErrorType.unknown,
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        LocationError(
          message: 'Error al iniciar el seguimiento: $e',
          errorType: LocationErrorType.unknown,
        ),
      );
    }
  }

  /// Detiene el seguimiento de ubicación
  Future<void> _onStopLocationTracking(
    StopLocationTracking event,
    Emitter<LocationState> emit,
  ) async {
    await _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    // Mantener la última ubicación conocida
    if (_locationHistory.isNotEmpty) {
      final lastPosition = _locationHistory.last;
      emit(LocationLoaded(position: lastPosition, timestamp: DateTime.now()));
    } else {
      emit(const LocationInitial());
    }
  }

  /// Actualiza la configuración de ubicación (para implementaciones futuras)
  Future<void> _onUpdateLocationSettings(
    UpdateLocationSettings event,
    Emitter<LocationState> emit,
  ) async {
    // Esta funcionalidad se puede implementar para cambiar
    // configuraciones como precisión, filtro de distancia, etc.
    // Por ahora solo emitimos el estado actual
  }
}
